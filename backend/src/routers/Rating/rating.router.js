const express = require("express");
const router = express.Router();
const ratingController = require("../../controllers/Rating/rating.controller");
const { verifyToken } = require("../../middlewares/verifyToken");

router.post("/:idBill/:idItem", verifyToken, ratingController.addRating);
router.post("/:idRating", verifyToken, ratingController.updateRating);
router.get("/:idItem", ratingController.getRatingsByItem);
router.get("/:idBill", ratingController.getRatingsByBill);
router.delete("/:idRating", verifyToken, ratingController.deleteRating);

module.exports = router;
