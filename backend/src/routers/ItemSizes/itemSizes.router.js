const express = require("express");
const ItemSizesController = require("../../controllers/ItemSizes/itemSizes.controller");
const { verifyToken } = require("../../middlewares/verifyToken");
const router = express.Router();

router.put("/:idItem", verifyToken, ItemSizesController.updateSizeQuantity);
router.get("/:idItem", ItemSizesController.getItemSizes);

module.exports = router;
