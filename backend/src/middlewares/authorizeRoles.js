const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");

const authorizeRoles = (...roles) => {
  return (req, res, next) => {

       if (!req.user || !req.user.role) {
         return res.status(403).json({ message: "User role not found." });
       }

       const userRole = req.user.role;

       if (roles.includes(userRole)) {
         next();
       } else {
         res
           .status(403)
           .json({ message: "Access denied. Insufficient permissions." });
       }
  };
};

module.exports = authorizeRoles;
