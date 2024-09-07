const prisma = require("../../config/prismaClient");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");
const { sendMail } = require("../../utils/sendMail");

class UserService {
  async register(email, password) {
    const userExist = await prisma.user.findUnique({
      where: {
        email,
      },
    });

    if (userExist) {
      throw new Error("User already exists");
    }

    const password_hash = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: {
        email,
        password_hash,
      },
    });

    await sendOtp(email);
      
    return {
      message: "Đăng ký người dùng thành công, vui lòng xác thực email",
      user,
    };
  }

  async login(email, password) {
    const user = await prisma.user.findUnique({
      where: {
        email,
      },
    });
      
    if (!user || !(await bcrypt.compare(password, user.password_hash))) {
      throw new Error("Invalid email or password");
    }
    
    if (user.otp) {
      throw new Error("Account not verified. Please verify your email.");
    }  
      
    if (user && (await bcrypt.compare(password, user.password_hash))) {
      const token = jwt.sign(
        {
          idUser: user.idUser,
        },
        process.env.JWT_SECRET,
        {
          expiresIn: "1week",
        }
        );
        
        res.cookie("token", token, {
          ...cookieOptions, 
          maxAge: 7 * 24 * 60 * 60 * 1000, 
        });


      return {
        user,
        message: "Login successful",
      };
    }
    throw new Error("Invalid email or password");
  }

  async logout(res) {
    res.cookie("token", "", {
      ...cookieOptions, 
      maxAge: 1, 
    });
    return {
      message: "Logout successful",
    };
  }

  async verifyOtp(email, otp) {
    const user = await prisma.user.findUnique({
      where: {
        email,
      },
    });
    if (user && user.otp === otp) {
      await prisma.user.update({
        where: {
          email,
        },
        data: {
          otp: null,
        },
      });
      return {
        message: "Email verified successfully",
      };
    }
    throw new Error("Invalid OTP");
  }

  async sendOtp(email) {
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    await prisma.user.update({
      where: {
        email,
      },
      data: {
        otp,
      },
    });
    await sendMail(email, "Your OTP Code", `Your OTP code is ${otp}`);
    return {
      message: "OTP sent successfully",
    };
  }

  async forgotPassword(email) {
    const resetToken = uuidv4();
    await prisma.user.update({
      where: {
        email,
      },
      data: {
        resetToken,
      },
    });
    await sendMail(
      email,
      "Password Reset",
      `Your reset token is ${resetToken}`
    );
    return {
      message: "Password reset token sent",
    };
  }

  async resetPassword(email, resetToken, newPassword) {
    const user = await prisma.user.findUnique({
      where: {
        email,
      },
    });
    if (user && user.resetToken === resetToken) {
      const password_hash = await bcrypt.hash(newPassword, 10);
      await prisma.user.update({
        where: {
          email,
        },
        data: {
          password_hash,
          resetToken: null,
        },
      });
      return {
        message: "Password reset successfully",
      };
    }
    throw new Error("Invalid reset token");
  }

  async getAllUsers() {
    return await prisma.user.findMany();
  }

  async getUserById(idUser) {
    return await prisma.user.findUnique({
      where: {
        idUser,
      },
    });
  }

  async getUserByEmail(email) {
    return await prisma.user.findUnique({
      where: {
        email,
      },
    });
  }

  async getLoggedInUser(idUser) {
    return await this.getUserById(idUser);
  }

  async updateUserField(idUser, field, value) {
    const data = {};
    data[field] = value;
    return await prisma.user.update({
      where: {
        idUser,
      },
      data,
    });
  }

  async updateUserFields(idUser, fields) {
    return await prisma.user.update({
      where: {
        idUser,
      },
      data: fields,
    });
  }

  async updateUser(idUser, data) {
    return await prisma.user.update({
      where: {
        idUser,
      },
      data,
    });
  }

  async deleteUser(idUser) {
    return await prisma.user.delete({
      where: {
        idUser,
      },
    });
  }
}

module.exports = new UserService();
