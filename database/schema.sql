-- PostgreSQL schema for trust-first freelance marketplace

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE user_role AS ENUM ('client', 'freelancer', 'admin');
CREATE TYPE user_status AS ENUM ('pending_verification', 'active', 'suspended', 'banned');
CREATE TYPE project_status AS ENUM ('draft', 'open', 'in_progress', 'completed', 'cancelled', 'disputed');
CREATE TYPE milestone_status AS ENUM ('pending_funding', 'funded', 'in_progress', 'submitted', 'approved', 'rejected', 'disputed', 'released', 'refunded');
CREATE TYPE transaction_type AS ENUM ('deposit', 'release', 'refund', 'fee', 'chargeback', 'adjustment');
CREATE TYPE dispute_status AS ENUM ('open', 'under_review', 'awaiting_evidence', 'ai_recommended', 'resolved', 'closed');
CREATE TYPE message_type AS ENUM ('text', 'file', 'system');

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  role user_role NOT NULL,
  email CITEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL,
  avatar_url TEXT,
  status user_status NOT NULL DEFAULT 'pending_verification',
  trust_score NUMERIC(5,2) NOT NULL DEFAULT 50.00 CHECK (trust_score BETWEEN 0 AND 100),
  kyc_verified BOOLEAN NOT NULL DEFAULT FALSE,
  two_factor_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  scope_ai_summary JSONB,
  scope_ai_risk_score NUMERIC(5,2) DEFAULT 0 CHECK (scope_ai_risk_score BETWEEN 0 AND 100),
  budget_currency CHAR(3) NOT NULL,
  total_budget NUMERIC(12,2) NOT NULL CHECK (total_budget > 0),
  status project_status NOT NULL DEFAULT 'draft',
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE project_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  freelancer_id UUID NOT NULL REFERENCES users(id),
  accepted_at TIMESTAMPTZ,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE(project_id, freelancer_id)
);

CREATE TABLE milestones (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
  due_date DATE,
  sequence_no INTEGER NOT NULL CHECK (sequence_no > 0),
  status milestone_status NOT NULL DEFAULT 'pending_funding',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(project_id, sequence_no)
);

CREATE TABLE escrow_accounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID UNIQUE NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  provider TEXT NOT NULL CHECK (provider IN ('stripe', 'razorpay')),
  provider_account_ref TEXT NOT NULL,
  balance NUMERIC(12,2) NOT NULL DEFAULT 0,
  locked_balance NUMERIC(12,2) NOT NULL DEFAULT 0,
  currency CHAR(3) NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE escrow_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  escrow_account_id UUID NOT NULL REFERENCES escrow_accounts(id) ON DELETE CASCADE,
  milestone_id UUID REFERENCES milestones(id),
  type transaction_type NOT NULL,
  amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
  status TEXT NOT NULL CHECK (status IN ('pending', 'succeeded', 'failed', 'reversed')),
  provider_reference TEXT,
  idempotency_key TEXT UNIQUE NOT NULL,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE milestone_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  milestone_id UUID NOT NULL REFERENCES milestones(id) ON DELETE CASCADE,
  freelancer_id UUID NOT NULL REFERENCES users(id),
  notes TEXT,
  plagiarism_score NUMERIC(5,2) CHECK (plagiarism_score BETWEEN 0 AND 100),
  authenticity_flags JSONB,
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  reviewed_at TIMESTAMPTZ
);

CREATE TABLE files (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  uploader_id UUID NOT NULL REFERENCES users(id),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  milestone_id UUID REFERENCES milestones(id) ON DELETE SET NULL,
  s3_key TEXT NOT NULL UNIQUE,
  original_name TEXT NOT NULL,
  mime_type TEXT NOT NULL,
  size_bytes BIGINT NOT NULL,
  sha256_hash TEXT NOT NULL,
  malware_scan_status TEXT NOT NULL DEFAULT 'pending' CHECK (malware_scan_status IN ('pending', 'clean', 'infected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE chats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE chat_participants (
  chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  PRIMARY KEY(chat_id, user_id)
);

CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES users(id),
  type message_type NOT NULL,
  body TEXT,
  file_id UUID REFERENCES files(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE disputes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  milestone_id UUID REFERENCES milestones(id) ON DELETE SET NULL,
  raised_by UUID NOT NULL REFERENCES users(id),
  reason TEXT NOT NULL,
  status dispute_status NOT NULL DEFAULT 'open',
  ai_recommendation JSONB,
  ai_confidence NUMERIC(5,2) CHECK (ai_confidence BETWEEN 0 AND 100),
  admin_decision JSONB,
  resolved_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  from_user UUID NOT NULL REFERENCES users(id),
  to_user UUID NOT NULL REFERENCES users(id),
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(project_id, from_user, to_user)
);

CREATE TABLE trust_signals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  signal_type TEXT NOT NULL,
  signal_value NUMERIC(10,4) NOT NULL,
  source TEXT NOT NULL,
  metadata JSONB,
  observed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE activity_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  actor_id UUID REFERENCES users(id),
  entity_type TEXT NOT NULL,
  entity_id UUID,
  action TEXT NOT NULL,
  details JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_projects_client_id ON projects(client_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_milestones_project_id ON milestones(project_id);
CREATE INDEX idx_escrow_transactions_account_created ON escrow_transactions(escrow_account_id, created_at DESC);
CREATE INDEX idx_messages_chat_created ON messages(chat_id, created_at DESC);
CREATE INDEX idx_activity_logs_entity ON activity_logs(entity_type, entity_id, created_at DESC);
CREATE INDEX idx_trust_signals_user_observed ON trust_signals(user_id, observed_at DESC);
