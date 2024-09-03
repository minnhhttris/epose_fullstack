const express = require('express');
const userRouter = require('./User/user.router');

const router = express.Router();

router.use('/users', userRouter);

module.exports = router;