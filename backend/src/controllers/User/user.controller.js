const UserService = require('../../services/User/user.service');

class UserController {
    async register(req, res) {
        try {
            const { email, password } = req.body;
            const user = await UserService.register(email, password);
            res.status(201).json({
                message: 'Đăng ký tài khoản thành công!',
                data: user,
            });
        } catch (error) {
            console.error(error);
            res.status(400).json({
                message: 'Không thể đăng ký. Vui lòng thử lại!',
                error: error.message,
            });
        }
    }

    async login(req, res) {
        try {
            const { email, password } = req.body;
            const { user, token } = await UserService.login(email, password);
            res.cookie('token', token, require('../../config/cookieOptions'));
            res.status(200).json({
                message: 'Đăng nhập thành công!',
                data: user,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Đăng nhập không thành công. Vui lòng kiểm tra lại thông tin!',
                error: error.message,
            });
        }
    }

    async logout(req, res) {
        try {
            await UserService.logout(res);
            res.status(200).json({
                message: 'Đăng xuất thành công!',
            });
        } catch (error) {
            res.status(400).json({
                message: 'Đăng xuất không thành công. Vui lòng thử lại!',
                error: error.message,
            });
        }
    }

    async verifyOtp(req, res) {
        try {
            const { email, otp } = req.body;
            const result = await UserService.verifyOtp(email, otp);
            res.status(200).json({
                message: 'Xác minh OTP thành công!',
                data: result,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Xác minh OTP thất bại. Vui lòng thử lại!',
                error: error.message,
            });
        }
    }

    async sendOtp(req, res) {
        try {
            const { email } = req.body;
            const result = await UserService.sendOtp(email);
            res.status(200).json({
                message: 'OTP đã được gửi đến email của bạn!',
                data: result,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Có lối xảy ra. Vui lòng thử lại!',
                error: error.message,
            });
        }
    }

    async forgotPassword(req, res) {
        try {
            const { email } = req.body;
            const result = await UserService.forgotPassword(email);
            res.status(200).json({
                message: 'Hướng dẫn khôi phục mật khẩu đã được gửi đến email của bạn!',
                data: result,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể gửi email khôi phục mật khẩu. Vui lòng thử lại!',
                error: error.message,
            });
        }
    }

    async resetPassword(req, res) {
        try {
            const { email, resetToken, newPassword } = req.body;
            const result = await UserService.resetPassword(email, resetToken, newPassword);
            res.status(200).json({
                message: 'Mật khẩu đã được thay đổi thành công!',
                data: result,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể đặt lại mật khẩu. Vui lòng thử lại!',
                error: error.message,
            });
        }
    }

    async getAllUsers(req, res) {
        try {
            const users = await UserService.getAllUsers();
            res.status(200).json({
                message: 'Lấy danh sách người dùng thành công!',
                data: users,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể lấy danh sách người dùng!',
                error: error.message,
            });
        }
    }

    async getUserById(req, res) {
        try {
            const { idUser } = req.params;
            const user = await UserService.getUserById(idUser);
            res.status(200).json({
                message: 'Lấy thông tin người dùng thành công!',
                data: user,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể lấy thông tin người dùng!',
                error: error.message,
            });
        }
    }

    async getUserByEmail(req, res) {
        try {
            const { email } = req.params;
            const user = await UserService.getUserByEmail(email);
            res.status(200).json({
                message: 'Lấy thông tin người dùng thành công!',
                data: user,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể lấy thông tin người dùng!',
                error: error.message,
            });
        }
    }

    async getLoggedInUser(req, res) {
        try {
            const { idUser } = req.user;
            const user = await UserService.getLoggedInUser(idUser);
            res.status(200).json({
                message: 'Lấy thông tin người dùng hiện tại thành công!',
                data: user,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể lấy thông tin người dùng hiện tại!',
                error: error.message,
            });
        }
    }

    async updateUserField(req, res) {
        try {
            const { idUser } = req.params;
            const { field, value } = req.body;
            const user = await UserService.updateUserField(idUser, field, value);
            res.status(200).json({
                message: 'Cập nhật thông tin thành công!',
                data: user,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể cập nhật thông tin!',
                error: error.message,
            });
        }
    }

    async updateUserFields(req, res) {
        try {
            const { idUser } = req.params;
            const fields = req.body;
            const user = await UserService.updateUserFields(idUser, fields);
            res.status(200).json({
                message: 'Cập nhật nhiều trường thông tin thành công!',
                data: user,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể cập nhật thông tin!',
                error: error.message,
            });
        }
    }

    async updateUser(req, res) {
        try {
            const { idUser } = req.params;
            const data = req.body;
            const user = await UserService.updateUser(idUser, data);
            res.status(200).json({
                message: 'Cập nhật người dùng thành công!',
                data: user,
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể cập nhật người dùng!',
                error: error.message,
            });
        }
    }

    async deleteUser(req, res) {
        try {
            const { idUser } = req.params;
            const { idUser: userIdFromToken, role } = req.user;

            if (role !== 'admin' && userIdFromToken !== idUser) {
                return res.status(403).json({
                    message: 'Bạn không có quyền xóa tài khoản này!',
                });
            }

            await UserService.deleteUser(idUser);
            res.status(200).json({
                message: 'Tài khoản đã được xóa thành công!',
            });
        } catch (error) {
            res.status(400).json({
                message: 'Không thể xóa tài khoản. Vui lòng thử lại!',
                error: error.message,
            });
        }
    }
}

module.exports = new UserController();
