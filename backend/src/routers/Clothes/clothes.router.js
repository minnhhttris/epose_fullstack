const express = require("express");
const ClothesController = require("../../controllers/Clothes/clothes.controller");
const { verifyToken } = require("../../middlewares/verifyToken");
const authorizeRoles = require("../../middlewares/authorizeRoles");

const router = express.Router();

router.post("/:idStore/createClothes", verifyToken, authorizeRoles('admin', 'owner', 'employee'), ClothesController.createClothes);
router.put("/:idItem/updateClothes", verifyToken, authorizeRoles('admin', 'owner', 'employee'), ClothesController.updateClothes);
router.get("/:idStore", ClothesController.getClothesByStore);
router.get("/:idItem", ClothesController.getClothesById);
router.get("/getAllClothes", ClothesController.getAllClothes);
router.delete(
  "/:idStore/deleteClothes",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  ClothesController.deleteClothes
);
module.exports = router;