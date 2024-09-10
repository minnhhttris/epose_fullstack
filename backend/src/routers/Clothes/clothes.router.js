const express = require("express");
const ClothesController = require("../../controllers/Clothes/clothes.controller");
const verifyToken = require("../../middlewares/verifyToken");

const router = express.Router();

router.post("/:idStore/createClothes", verifyToken, ClothesController.createClothes);
router.put("/:idItem/updateClothes", verifyToken, ClothesController.updateClothes);
router.get("/:idStore", ClothesController.getClothesByStore);
router.get("/:idItem", ClothesController.getClothesById);
router.get("/getAllClothes", ClothesController.getAllClothes);
router.delete("/:idStore/deleteClothes", ClothesController.delete);
module.exports = router;