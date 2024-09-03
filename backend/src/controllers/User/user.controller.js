const UserService = require('../../services/User/user.service');

class UserController {
    async register(req, res) {
        try {
            const {
                email,
                password
            } = req.body;
            const user = await UserService.register(email, password);
            res.status(201).json(user);
        } catch (error) {
            console.error(error);
            res.status(400).json({
                error: error.message
            });
        }
    }

    async login(req, res) {
        try {
            const {
                email,
                password
            } = req.body;
            const {
                user,
                token
            } = await UserService.login(email, password);
            res.cookie('token', token, require('../../config/cookieOptions'));
            res.json(user);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async logout(req, res) {
        try {
            await UserService.logout(res);
            res.json({
                message: 'Logged out successfully'
            });
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async verifyOtp(req, res) {
        try {
            const {
                email,
                otp
            } = req.body;
            const result = await UserService.verifyOtp(email, otp);
            res.json(result);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async resendOtp(req, res) {
        try {
            const {
                email
            } = req.body;
            const result = await UserService.resendOtp(email);
            res.json(result);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async forgotPassword(req, res) {
        try {
            const {
                email
            } = req.body;
            const result = await UserService.forgotPassword(email);
            res.json(result);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async resetPassword(req, res) {
        try {
            const {
                email,
                resetToken,
                newPassword
            } = req.body;
            const result = await UserService.resetPassword(email, resetToken, newPassword);
            res.json(result);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async getAllUsers(req, res) {
        try {
            const users = await UserService.getAllUsers();
            res.json(users);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async getUserById(req, res) {
        try {
            const {
                idUser
            } = req.params;
            const user = await UserService.getUserById(idUser);
            res.json(user);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async getUserByEmail(req, res) {
        try {
            const {
                email
            } = req.params;
            const user = await UserService.getUserByEmail(email);
            res.json(user);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async getLoggedInUser(req, res) {
        try {
            const {
                idUser
            } = req.user;
            const user = await UserService.getLoggedInUser(idUser);
            res.json(user);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async updateUserField(req, res) {
        try {
            const {
                idUser
            } = req.params;
            const {
                field,
                value
            } = req.body;
            const user = await UserService.updateUserField(idUser, field, value);
            res.json(user);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async updateUserFields(req, res) {
        try {
            const {
                idUser
            } = req.params;
            const fields = req.body;
            const user = await UserService.updateUserFields(idUser, fields);
            res.json(user);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async updateUser(req, res) {
        try {
            const {
                idUser
            } = req.params;
            const data = req.body;
            const user = await UserService.updateUser(idUser, data);
            res.json(user);
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }

    async deleteUser(req, res) {
        try {
            const {
                idUser
            } = req.params;
            const {
                idUser: userIdFromToken,
                role
            } = req.user;

            if (role !== 'admin' && userIdFromToken !== idUser) {
                return res.status(403).json({
                    message: 'Bạn không có quyền xóa tài khoản này!'
                });
            }

            await UserService.deleteUser(idUser);
            res.json({
                message: 'Tài khoản đã được xóa thành công'
            });
        } catch (error) {
            res.status(400).json({
                error: error.message
            });
        }
    }
}

module.exports = new UserController();