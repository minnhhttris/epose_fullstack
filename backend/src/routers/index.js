const express = require('express');
const userRouter = require('./User/user.router');
const storeRouter = require('./Store/store.router');
const clothesRouter = require('./Clothes/clothes.router');
const postsRouter = require("./Posts/posts.router");
const bagShoppingRouter = require("./BagShopping/bagShopping.router");
const commentsRouter = require("./Comment/comment.router");
const billRouter = require("./Bill/bill.router");
const paymentRouter = require("./PaymentVNPay/payment.router");

const router = express.Router();

router.use('/users', userRouter);
router.use('/stores', storeRouter);
router.use('/clothes', clothesRouter);
router.use('/posts', postsRouter);
router.use('/bagShopping', bagShoppingRouter);
router.use('/comment', commentsRouter);
router.use('/bill', billRouter);
router.use("/payments", paymentRouter);

module.exports = router;