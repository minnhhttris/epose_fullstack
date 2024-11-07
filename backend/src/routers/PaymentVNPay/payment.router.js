const express = require("express");
const router = express.Router();
const paymentController = require("../../controllers/PaymentVNPay/payment.controller");

// Route tạo URL thanh toán
router.post("/create_payment_url", paymentController.createPaymentVnpayUrl);

// Route xử lý phản hồi từ VNPAY sau khi thanh toán
router.get("/vnpay_return", paymentController.vnpayReturn);

module.exports = router;
