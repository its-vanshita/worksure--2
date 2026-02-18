export function activityLog(req, _res, next) {
  req.logActivity = (action, details = {}) => {
    const entry = {
      action,
      path: req.path,
      method: req.method,
      actorId: req.user?.sub,
      details,
      createdAt: new Date().toISOString()
    };
    // Replace with DB insert / queue in production.
    console.info('[activity]', JSON.stringify(entry));
  };
  next();
}
