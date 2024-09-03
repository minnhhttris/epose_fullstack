const jwt = require('jsonwebtoken');
const prisma = require('../config/prismaClient');

const verifyToken = (req, res, next) => {
    const token = req.headers['authorization'];

    if (!token) return res.status(403).send("Token không hợp lệ!");

    jwt.verify(token, process.env.JWT_SECRET, async (err, decoded) => {
        if (err) return res.status(401).send("Token hết hạn hoặc không hợp lệ!");

        // Save user -> req
        req.user = decoded;
        const user = await prisma.user.findUnique({
            where: {
                idUser: decoded.idUser
            },
        });

        if (!user) return res.status(404).send("Không tìm thấy người dùng!");

        req.user.role = user.role;
        next();
    });
};

// Check role
const checkRole = (...allowedRoles) => {
    return (req, res, next) => {
        if (!allowedRoles.includes(req.user.role)) {
            return res.status(403).send("Bạn không có quyền truy cập vào tài nguyên này!");
        }
        next();
    };
};

module.exports = {
    verifyToken,
    checkRole
};