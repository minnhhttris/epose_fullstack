const express = require('express');
const UserController = require('../../controllers/User/user.controller');
const { verifyToken } = require('../../middlewares/verifyToken');
const authorizeRoles = require('../../middlewares/authorizeRoles');

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
  authorizeRoles("admin"),
  UserController.getAllUsers
);
router.get('/me', verifyToken, UserController.getLoginUser);
router.get("/:idUser", verifyToken, UserController.getUserByIdUser);

router.post('/updateUser', verifyToken, UserController.updateUserField);

router.delete(
  "/:idUser",
  verifyToken,
  authorizeRoles("admin"),
  UserController.deleteUser
);

module.exports = router;