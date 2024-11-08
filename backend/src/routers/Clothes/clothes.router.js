const express = require("express");
const clothesController = require("../../controllers/Clothes/clothes.controller");
const { verifyToken } = require("../../middlewares/verifyToken");
const authorizeRoles = require("../../middlewares/authorizeRoles");
const upload = require("../../config/multerConfig");

const router = express.Router();

router.post(
  "/store/:idStore/createClothes",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  upload.uploadClothesImages,
  clothesController.createClothes
);

router.post(
  "/:idItem/updateQuantity",
  verifyToken,
  clothesController.updateClothesQuantity
);

router.put(
  "/:idItem",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  upload.uploadClothesImages,
  clothesController.updateClothes
);

router.get("/store/:idStore/", clothesController.getClothesByStore);
router.get("/:idItem", clothesController.getClothesById);
router.get("/", clothesController.getAllClothes);

router.delete(
  "/:idItem",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  clothesController.deleteClothes
);
module.exports = router;