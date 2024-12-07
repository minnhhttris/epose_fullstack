const express = require("express");
const clothesStatusController = require("../../controllers/ClothesStatus/clothesStatus.controller");
const { verifyToken } = require("../../middlewares/verifyToken");
const authorizeRoles = require("../../middlewares/authorizeRoles");
const upload = require("../../config/multerConfig");

const router = express.Router();

// Tạo trạng thái quần áo mới
router.post(
  "/bill/:idBill/createClothesStatus",
  verifyToken,
  upload.uploadClothesStatusImages,
  clothesStatusController.createClothesStatus
);

// Cập nhật trạng thái quần áo
router.put(
  "/status/:idStatus",
  verifyToken,
  upload.uploadClothesStatusImages,
  clothesStatusController.updateClothesStatus
);

// Xóa trạng thái quần áo
router.delete(
  "/status/:idStatus",
  verifyToken,
  clothesStatusController.deleteClothesStatus
);

// Lấy danh sách trạng thái quần áo theo idBill
router.get(
  "/bill/:idBill/statuses",
  verifyToken,
  clothesStatusController.getClothesStatusesByBill
);

// Lấy trạng thái quần áo theo idBillItem
router.get(
  "/bill-item/:idBillItem/status",
  verifyToken,
  clothesStatusController.getClothesStatusByBillItem
);

module.exports = router;
