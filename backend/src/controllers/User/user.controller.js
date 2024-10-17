const UserService = require("../../services/User/user.service");
const USER_VALIDATES = require("../../models/User/validate/user.validate");
const MailQueue = require("../../utils/sendMail");
const COOKIE_OPTIONS = require("../../config/cookieOptions");

class UserController {
  async register(req, res) {
    const userData = req.body;
    const otpType = "create_account";

    const { error, value } = USER_VALIDATES.registerValidate.validate(userData);

    if (error) {
      const errors = error.details.reduce((acc, current) => {
        acc[current.context.key] = current.message;
        return acc;
      }, {});
      return res.status(400).json({ errors });
    }

    try {
      const checkUserExist = await UserService.checkUserExists(userData.email);
      if (checkUserExist) {
        return res.status(400).json({
          message: "Người dùng đã tồn tại!",
        });
      }
      const user = await UserService.register(userData);
      const sendMail = await MailQueue.sendVerifyEmail(userData.email, otpType);
      if (!sendMail) {
        return res.status(400).json({
          message: "Không thể gửi email xác thực. Vui lòng thử lại!",
        });
      }
      return res.status(200).json({
        success: true,
        message: "Đăng ký người dùng thành công, vui lòng xác thực email!",
        user: user,
      });
    } catch (error) {
      console.error("Error registering user:", error);
      return res.status(500).json({
        success: false,
        message: "Đăng ký người dùng thất bại!!!",
        error: error.message,
      });
    }
  }

  async verifyOTPAndActivateUser(req, res) {
    const { email, otp } = req.body;

    try {
      const activatedUser = await UserService.verifyOTPAndActivateUser(
        email,
        otp
      );

      if (!activatedUser)
        return res.status(400).json({
          error: { otp: "Mã OTP không chính xác hoặc đã hết hạn" },
        });

      return res.status(200).json({
        success: true,
        message: "Xác minh OTP thành công!",
        data: activatedUser,
      });
    } catch (error) {
      console.error("Error verifying OTP:", error);
      return res.status(400).json({
        success: false,
        message: "Xác minh OTP thất bại!",
        error: error.message,
      });
    }
  }

  async forgotPassword(req, res) {
    try {
      const { email } = req.body;
      const existingEmail = await UserService.checkUserExists(email);
      if (!existingEmail) {
        return res.status(400).json({
          message: "Email người dùng không tồn tại!",
        });
      }

      const sendMail = await MailQueue.sendForgotPasswordEmail(email);
      if (!sendMail) {
        throw new Error("Gửi email xác minh thất bại!");
      }

      return res.status(200).json({
        success: true,
        message: "Vui lòng kiểm tra email để xác thực!",
      });
    } catch (error) {
      console.error("Error sending forgot password email:", error);
      return res.status(500).json({
        success: false,
        message: "Không thể gửi email khôi phục mật khẩu!",
        error: error.message,
      });
    }
  }

  async resendOTP(req, res) {
    try {
      const { email } = req.body;
      const existingEmail = await UserService.checkUserExists(email);
      if (!existingEmail) {
        return res.status(400).json({
          message: "Email người dùng không tồn tại!",
        });
      }

      const sendMail = await MailQueue.ResendOtp(email);
      if (!sendMail) {
        throw new Error("Gửi lại email xác minh thất bại");
      }

      return res.status(201).json({
        success: true,
        message: "Vui lòng kiểm tra email của bạn.",
      });
    } catch (error) {
      console.error("Error handling resendOTP request:", error);
      return res.status(500).json({
        success: false,
        message: "Đã xảy ra lỗi khi xử lý yêu cầu.",
      });
    }
  }

  async resetPassword(req, res) {
    const { email, otp, newPassword } = req.body;
    try {
      const isValid = await MailQueue.verifyOTP(email, otp, "reset_password");
      if (!isValid) {
        return res.status(500).json({ error: "Invalid or expired OTP." });
      }
      await UserService.resetPassword(email, newPassword, otp);
      return res.status(200).json({ message: "Password reset successfully." });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể đặt lại mật khẩu! Đã có lỗi xảy ra!",
        error: error.message,
      });
    }
  }

  async login(req, res) {
    const userData = req.body;

    try {
      const user = await UserService.checkUserExists(userData.email);
      if (!user) {
        return res.status(401).json({ message: "Người dùng không tồn tại!" });
      }

      const isPasswordValid = await UserService.checkPassword(
        userData.password,
        user.password_hash
      );

      if (!isPasswordValid) {
        return res
          .status(401)
          .json({ success: false, message: "Mật khẩu không chính xác!" });
      }

      const dataSign = {
        idUser: user.idUser,
      };

      const { accessToken, refreshToken } = await UserService.login(dataSign);

      res.cookie("refreshToken", refreshToken, COOKIE_OPTIONS);
      return res.status(200).json({
        success: true,
        accessToken: accessToken,
      });
    } catch (error) {
      console.error("Error logging in user:", error);
      res.status(400).json({
        message: "Đăng nhập không thành công. Vui lòng kiểm tra lại thông tin!",
        error: error.message,
      });
    }
  }

  async logout(req, res) {
    res.clearCookie("refreshToken", COOKIE_OPTIONS);
    res.status(200).json({
      message: "Đăng xuất thành công!",
    });
  }

  async refreshToken(req, res) {
    try {
      const { refreshToken } = req.cookies;
      if (!refreshToken) {
        return res.status(403).json({
          message: "Không tìm thấy token!",
        });
      }

      const newRefreshToken = await UserService.resetRefreshToken(refreshToken);

      const decoded = jwt.verify(
        refreshToken,
        process.env.REFRESH_TOKEN_SECRET
      );

      const accessToken = jwt.sign(
        { idUser: decoded.idUser },
        process.env.ACCESS_TOKEN_SECRET,
        { expiresIn: "5h" }
      );

      res.cookie("refreshToken", newRefreshToken, COOKIE_OPTIONS);
      return res.status(200).json({
        accessToken,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể làm mới token!",
        error: error.message,
      });
    }
  }

  async getAllUsers(req, res) {
    try {
      const userData = req.body;
      const users = await UserService.getAllUsers();
      res.status(200).json({
        message: "Lấy danh sách người dùng thành công!",
        data: users,
      });
    } catch (error) {
      res.status(400).json({
        message: "Không thể lấy danh sách người dùng!",
        error: error.message,
      });
    }
  }

  async getLoginUser(req, res) {
    try {
      const idUser = req.user_id;

      const user = await UserService.getUserById(idUser);

      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }

      res.status(200).json({
        message: "Lấy thông tin người dùng thành công!",
        success: true,
        data: user,
      });
    } catch (error) {
      res.status(400).json({
        message: "Không thể lấy thông tin người dùng!",
        success: false,
        error: error.message,
      });
    }
  }

  async getUserByIdUser(req, res) {
    try {
      const idUser = req.params.id;

      const user = await UserService.getUserById(idUser);

      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }

      res.status(200).json({
        message: "Lấy thông tin người dùng thành công!",
        success: true,
        data: user,
      });
    } catch (error) {
      res.status(400).json({
        message: "Không thể lấy thông tin người dùng!",
        success: false,
        error: error.message,
      });
    }
  }

  async updateUserField(req, res) {
    const idUser = req.user_id;
    const userData = req.body;
    const otpType = "edit_account";

    try {
      const user = await UserService.getUserById(idUser);

      if (userData.password) {
        const hashedPassword = await bcrypt.hash(userData.password, 10);
        userData.password_hash = hashedPassword;
        delete userData.password;
      }

      if (userData.email) {
        const checkUserExists = await UserService.checkUserExists(
          userData.email
        );

        if (checkUserExists) {
          return res.status(400).json({
            message: "Email đã tồn tại!",
          });
        }

        const sendMail = await MailQueue.sendVerifyEmail(
          userData.email,
          otpType
        );

        if (!sendMail) {
          return res.status(400).json({
            message: "Không thể gửi email xác thực. Vui lòng thử lại!",
          });
        }
      }

      const updateUser = await UserService.updateUserField(idUser, userData);

      res.status(200).json({
        message: "Cập nhật thông tin thành công!",
        data: updateUser,
      });
    } catch (error) {
      res.status(400).json({
        message: "Không thể cập nhật thông tin!",
        error: error.message,
      });
    }
  }

  async deleteUser(req, res) {
    try {
      const userData = req.body;
      const idUser = req.idUser;
      const { idUser: userIdFromToken, role } = req.user;

      if (role !== "admin" && userIdFromToken !== userData.idUser) {
        return res.status(403).json({
          message: "Bạn không có quyền xóa tài khoản này!",
        });
      }

      await UserService.deleteUser(idUser);
      res.status(200).json({
        message: "Tài khoản đã xóa thành công!",
      });
    } catch (error) {
      res.status(400).json({
        message: "Không thể xóa tài khoản. Vui lòng thử lại!",
        error: error.message,
      });
    }
  }
}

module.exports = new UserController();
