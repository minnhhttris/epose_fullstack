const prisma = require('../config/prismaClient');

const checkUserIdentity = async (req, res, next) => {
  const { idUser } = req.body;

  try {
    const user = await prisma.user.findUnique({
      where: { idUser },
    });

    const requiredFields = ['userName', 'phoneNumbers', 'address', 'email', 'CCCD', 'CCCD_img', 'gender', 'dateOfBirth'];
    const missingFields = requiredFields.filter(field => !user[field] || (Array.isArray(user[field]) && user[field].length === 0));

    if (missingFields.length > 0) {
      return res.status(400).json({ success: false, message: "Người dùng chưa hoàn thành định danh tài khoản." });
    }

    next();
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = checkUserIdentity;
