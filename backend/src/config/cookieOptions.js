const jwt = require("jsonwebtoken");

const cookieOptions = {
    httpOnly: true,
    secure: false,
    sameSite: 'strict',
    path: "/",
    //maxAge: 24 * 60 * 60 * 1000, 
};

module.exports = cookieOptions;