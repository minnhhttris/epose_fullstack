const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const UserService = require("../services/User/user.service");

dotenv.config();

const verifyToken = async (req, res, next) => {
  const authHeader = req.header("Authorization");
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res
      .status(401)
      .json({ message: "Authorization token is required." });
  }

  try {
    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
    req.user_id = decoded.userId;

    // Use UserService to get user info
    req.user = await UserService.getUserById(decoded.userId);

    if (!req.user) {
      return res.sendStatus(404);
    }
    next();
  } catch (err) {
    return res.status(401).json({ message: "Invalid token." });
  }
};

const verifyTokenAdmin = async (req, res, next) => {
  const authHeader = req.header("Authorization");
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res
      .status(401)
      .json({ message: "Authorization token is required." });
  }

  try {
    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
    const user_info = await UserService.getUserById(decoded.userId);

    if (!user_info) {
      return res.status(404).json({ message: "User not found." });
    }

    if (user_info.role !== "admin") {
      return res.status(403).json({ error: "Access denied. Admins only." });
    }

    req.user = user_info;
    next();
  } catch (err) {
    return res.status(401).json({ message: "Invalid token." });
  }
};

module.exports = { verifyToken, verifyTokenAdmin };
