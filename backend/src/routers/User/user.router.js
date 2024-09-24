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

router.post('/logout', verifyToken, UserController.logout);
router.get(
  "/all",
  verifyToken,
  authorizeRoles("admin"),
  UserController.getAllUsers
);
router.get('/:idUser', verifyToken, UserController.getUserById);
router.get('/me', verifyToken, UserController.getLoggedInUser);

router.patch('/field/:idUser', verifyToken, UserController.updateUserField);
router.put('/:idUser', verifyToken, UserController.updateUser);

router.delete(
  "/:idUser",
  verifyToken,
  authorizeRoles("admin"),
  UserController.deleteUser
);

module.exports = router;