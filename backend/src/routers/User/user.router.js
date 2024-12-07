const express = require('express');
const UserController = require('../../controllers/User/user.controller');
const { verifyToken } = require('../../middlewares/verifyToken');
const authorizeRoles = require('../../middlewares/authorizeRoles');
const upload = require("../../config/multerConfig");

const router = express.Router();

router.post('/register', UserController.register);
router.post('/login', UserController.login);
router.post('/forgot-password', UserController.forgotPassword);
router.post('/reset-password', UserController.resetPassword);

router.post("/verify-otp", UserController.verifyOTPAndActivateUser);
router.post("/resend-otp", UserController.resendOTP);

router.post('/logout', verifyToken, UserController.logout);
router.get(
  "/getAllUsers",
  verifyToken,
  UserController.getAllUsers
);
router.get('/me', verifyToken, UserController.getLoginUser);
router.get("/:idUser", verifyToken, UserController.getUserByIdUser);

router.post(
  "/updateUser",
  verifyToken,
  (req, res, next) => {
    console.log(req.query);
    console.log(req.query.type);
    console.log(req.query.type === "CCCD_img");
    console.log(req.files); 
    // Kiểm tra tham số `type` để xác định middleware nào cần áp dụng
    if (req.query.type === "avatar") {
      upload.uploadAvatar(req, res, (err) => {
        if (err) {
          return res.status(400).json({ message: "Upload avatar thất bại!" });
        }
        next();
      });
    } else if (req.query.type === "CCCD_img") {
      upload.uploadCCCD(req, res, (err) => {
        console.log(err);
        if (err) {
          return res.status(400).json({ message: "Upload CCCD_img thất bại!" });
        }
        next();
      });
    } else {
      next(); 
    }
  },
  UserController.updateUserField
);

router.post(
  "/updateUserByIdUser/:idUser",
  verifyToken,
  (req, res, next) => {
    // Kiểm tra tham số `type` để xác định middleware nào cần áp dụng
    if (req.query.type === "avatar") {
      upload.uploadAvatar(req, res, (err) => {
        if (err) {
          return res.status(400).json({ message: "Upload avatar thất bại!" });
        }
        next();
      });
    } else if (req.query.type === "CCCD_img") {
      upload.uploadCCCD(req, res, (err) => {
        if (err) {
          return res.status(400).json({ message: "Upload CCCD_img thất bại!" });
        }
        next();
      });
    } else {
      next();
    }
  },
  UserController.updateUserByIdUser
);

router.delete(
  "/:idUser",
  verifyToken,
  authorizeRoles("admin"),
  UserController.deleteUser
);

module.exports = router;