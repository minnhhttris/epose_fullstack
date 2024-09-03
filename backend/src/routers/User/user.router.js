const express = require('express');
const UserController = require('../../controllers/User/user.controller');
const {
    verifyToken,
    checkRole
} = require('../../middlewares/verifyToken');

const router = express.Router();

router.post('/register', UserController.register);
router.post('/login', UserController.login);
router.post('/logout', verifyToken, UserController.logout);
router.post('/verify-otp', UserController.verifyOtp);
router.post('/resend-otp', UserController.resendOtp);
router.post('/forgot-password', UserController.forgotPassword);
router.post('/reset-password', UserController.resetPassword);

router.get('/all', verifyToken, checkRole('admin'), UserController.getAllUsers);

router.get('/:idUser', verifyToken, UserController.getUserById);
router.get('/email/:email', verifyToken, UserController.getUserByEmail);
router.get('/me', verifyToken, UserController.getLoggedInUser);

router.patch('/field/:idUser', verifyToken, UserController.updateUserField);
router.patch('/fields/:idUser', verifyToken, UserController.updateUserFields);
router.put('/:idUser', verifyToken, UserController.updateUser);

router.delete('/:idUser', verifyToken, UserController.deleteUser);

module.exports = router;