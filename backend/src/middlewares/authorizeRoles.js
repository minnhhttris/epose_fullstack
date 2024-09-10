const authorizeRoles = (...roles) => {
  return async (req, res, next) => {
    try {
      const userRole = req.user.role;

      if (roles.includes(userRole)) {
        next();
      } else {
        res
          .status(403)
          .json({ message: "Access denied. Insufficient permissions." });
      }
    } catch (error) {
      res.status(500).json({ message: "Error authorizing roles." });
    }
  };
};

module.exports = authorizeRoles;
