const express = require("express");
const ItemSizesController = require("../../controllers/ItemSizes/itemSizes.controller");
const router = express.Router();

router.put("/:idItem", ItemSizesController.updateSizeQuantity);
router.get("/:idItem", ItemSizesController.getItemSizes);

module.exports = router;
