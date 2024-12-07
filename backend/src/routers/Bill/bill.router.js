const express = require("express");
const router = express.Router();
const billController = require("../../controllers/Bill/bill.controller");
const { verifyToken } = require("../../middlewares/verifyToken");
const authorizeRoles = require("../../middlewares/authorizeRoles");

router.post("/:idUser/:idStore", verifyToken, billController.createBill);

router.get("/:id", verifyToken, billController.getBillById);
router.get("/billLoginUser", verifyToken, billController.getBillByLoginUser);
router.get("/user/:idUser", verifyToken, billController.getBillByIdUser);
router.get(
  "/store/:idStore",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  billController.getBillByIdStore
);
router.get("/", verifyToken, authorizeRoles("admin") , billController.getAllBills);

router.put("/:id", verifyToken, billController.updateBill);


module.exports = router;
