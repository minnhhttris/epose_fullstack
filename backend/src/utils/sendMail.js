const nodemailer = require('nodemailer');

const sendOtpEmail = async (to, otp) => {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS,
        },
    });

    const mailOptions = {
        from: process.env.EMAIL_USER,
        to,
        subject: 'OTP Verification',
        text: `Your OTP is ${otp}`,
    };

    await transporter.sendMail(mailOptions);
};

module.exports = {
    sendOtpEmail
};