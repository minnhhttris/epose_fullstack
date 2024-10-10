const express = require("express");
const clothesController = require("../../controllers/Clothes/clothes.controller");
const { verifyToken } = require("../../middlewares/verifyToken");
const authorizeRoles = require("../../middlewares/authorizeRoles");

const router = express.Router();

router.post(
  "/store/:idStore/createClothes",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  clothesController.createClothes
);

router.put(
  "/:idItem",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  clothesController.updateClothes
);

router.get("/store/:idStore/", clothesController.getClothesByStore);
router.get("/:idItem", clothesController.getClothesById);
router.get("/", clothesController.getAllClothes);
router.get("/search", clothesController.searchClothes);

router.get("/style", clothesController.getClothesByStyle);
router.get("/color", clothesController.getClothesByColor);
router.get("/gender", clothesController.getClothesByGender);
router.get("/get10NewClothes", clothesController.get10NewClothes);

router.delete(
  "/:idItem",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  clothesController.deleteClothes
);
module.exports = router;