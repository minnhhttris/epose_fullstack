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

  async generateRefreshToken (userId) {
    const secret = process.env.REFRESH_TOKEN_SECRET;
    const expiresIn = "30d";
    const refreshToken = jwt.sign({ userId }, secret, { expiresIn });
    return refreshToken;
  };

  //create new refresh token
  async resetRefreshToken (oldRefreshToken) {
    const secret = process.env.REFRESH_TOKEN_SECRET;
    const decoded = jwt.verify(oldRefreshToken, secret);

    const newRefreshToken = generateRefreshToken(decoded.userId);
    return newRefreshToken;
  };

  async login(userData) {
    const secret = process.env.ACCESS_TOKEN_SECRET;
    const expiresIn = "5h";
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

    await prisma.otp.create({
      data: {
        code: otp,
        otpType: otpType,
        expTime: expTime,
        idUser: user.idUser,
      },
    });

    return user;
  }

  async updateOTPstatus(email, newStatus) {
    try {
      const otpRecord = await prisma.otp.findUnique({
        where: { code: otp },
      });

      if (!otpRecord) {
        throw new Error("OTP not found");
      }

      const updatedOTP = await prisma.otp.update({
        where: { idOTP: otpRecord.idOTP },
        data: { used: true },
      });

      return updatedOTP;
    } catch (error) {
      throw new Error("Error updating user OTP:", error);
    }
  }

  async resetPassword(email, newPassword, otp) {
    const hash = await this.hashPassword(newPassword);
    await prisma.user.update({
      where: { email },
      data: {
        password_hash: hash,
      },
    });
  }

  async getAllUsers() {
    return await prisma.user.findMany();
  }

  async getLoggedInUser(userData) {
    return await this.getUserById(userData.idUser);
  }

  async updateUserField(idUser, field, value) {
    const userData = {};
    userData[field] = value;
    return await prisma.user.update({
      where: {
        idUser,
      },
      userData,
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
