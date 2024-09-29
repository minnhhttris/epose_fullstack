const prisma = require("../../config/prismaClient");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

class UserService {
  async checkUserExists(email) {
    return await prisma.user.findUnique({
      where: {
        email,
      },
    });
  }

  async register(userData) {
    const password_hash = await this.hashPassword(userData.password);
    const user = await prisma.user.create({
      data: {
        email: userData.email,
        password_hash,
      },
    });

    return user;
  }

  async hashPassword(password) {
    return await bcrypt.hash(password, 10);
  }

  async checkPassword(password, password_hash) {
    try {
      return await bcrypt.compare(password, password_hash);
    } catch (error) {
      return false;
    }
  }

  async generateRefreshToken(userId) {
    const secret = process.env.REFRESH_TOKEN_SECRET;
    const expiresIn = "30d";
    const refreshToken = jwt.sign({ userId }, secret, { expiresIn });
    return refreshToken;
  }

  //create new refresh token
  async resetRefreshToken(oldRefreshToken) {
    const secret = process.env.REFRESH_TOKEN_SECRET;
    const decoded = jwt.verify(oldRefreshToken, secret);

    const newRefreshToken = generateRefreshToken(decoded.userId);
    return newRefreshToken;
  }

  async login(userData) {
    const secret = process.env.ACCESS_TOKEN_SECRET;
    const expiresIn = "1d";
    const accessToken = jwt.sign(userData, secret, { expiresIn });

    const refreshToken = await this.generateRefreshToken(userData.idUser);
    return { accessToken, refreshToken };
  }

  async getUserById(idUser) {
    const user = await prisma.user.findUnique({
      where: {
        idUser,
      },
    });

    if (!user) {
      throw new Error("User not found");
    }

    return user;
  }

  async updateUserOTP(email, otp, otpType, expTime) {
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new Error("User not found");
    }

    await prisma.oTP.create({
      data: {
        code: otp,
        otpType: otpType,
        expTime: expTime,
        idUser: user.idUser, // Liên kết mã OTP với người dùng
        check_used: false, // Mặc định là chưa sử dụng
      },
    });

    return user;
  }

  async updateOTPstatus(email, otp) {
    const otpRecord = await prisma.oTP.findFirst({
      where: {
        code: otp,
        user: {
          email: email,
        },
        check_used: false,
      },
    });

    if (!otpRecord || otpRecord.expTime < new Date()) {
      throw new Error("Mã OTP không chính xác hoặc đã hết hạn");
    }

    const updatedOTP = await prisma.oTP.update({
      where: { idOTP: otpRecord.idOTP },
      data: { check_used: true },
    });

    return updatedOTP;
  }

  async verifyOTPAndActivateUser(email, otp) {
    await this.updateOTPstatus(email, otp);

    const activatedUser = await prisma.user.update({
      where: { email: email },
      data: {
        isActive: true,
      },
    });

    return activatedUser;
  }

  async resetPassword(email, newPassword, otp) {
    const otpValid = await this.updateOTPstatus(email, otp);

    if (!otpValid) {
      throw new Error("OTP is invalid or expired");
    }

    const hash = await this.hashPassword(newPassword);
    const result = await prisma.user.update({
      where: { email },
      data: {
        password_hash: hash,
      },
    });

    return result;
  }

  async getAllUsers() {
    return await prisma.user.findMany();
  }

  async getLoggedInUser(userData) {
    return await this.getUserById(userData.idUser);
  }

  async updateUserField(idUser, field, value) {
    const updateData = {};
    
    if (field === "password") {
      const hashedPassword = await bcrypt.hash(value, 10); // Hash mật khẩu mới
      updateData.password_hash = hashedPassword;
    }
    else if (field === "email") {
      const checkUserExists = await prisma.user.findUnique({
        where: { email: value },
      });

      if (checkUserExists) {
        throw new Error("Email đã tồn tại");
      }

      updateData.email = value;
    }
    else {
      updateData[field] = value;
    }

    return await prisma.user.update({
      where: { id: idUser },
      data: updateData,
    });
  }

  async updateUser(userData) {
    return await prisma.user.update({
      where: {
        idUser,
      },
      data: {
        ...userData,
      },
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
