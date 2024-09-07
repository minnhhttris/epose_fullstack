const express = require('express');
const userRouter = require('./User/user.router');
const storeRouter = require('./Store/store.router');
const clothesRouter = require('./Clothes/clothes.router');
const itemSizesRouter = require('./ItemSizes/itemSizes.router');

const router = express.Router();

router.use('/users', userRouter);
router.use('/stores', storeRouter);
router.use('/clothes', clothesRouter);
router.use('/item-sizes', itemSizesRouter);

module.exports = router;