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
    req.user_id = decoded.idUser;
 
    if (!req.user_id) {
      return res.sendStatus(404);
    }

    const user = await UserService.getUserById(req.user_id);
    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }
    req.user = user;
    
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid token.' });
  }
};

module.exports = { verifyToken };
