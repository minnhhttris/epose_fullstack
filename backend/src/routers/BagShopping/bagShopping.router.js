const express = require("express");
const router = express.Router();
const bagShoppingController = require("../../controllers/BagShopping/bagShopping.controller");
const { verifyToken } = require("../../middlewares/verifyToken");

router.post(
  "/:idStore/:idItem",
  verifyToken,
  bagShoppingController.addToBagShopping
);

router.post("/:idItem", verifyToken, bagShoppingController.updateQuantity);

router.delete("/:idItem", verifyToken, bagShoppingController.removeFromBag);

router.get("/", verifyToken, bagShoppingController.getUserBag);

module.exports = router;
