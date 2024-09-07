const express = require('express');
const storeController = require('../../controllers/Store/store.controller');
const verifyToken = require('../../middlewares/verifyToken');
const checkUserIdentity = require('../../middlewares/checkUserIdentity'); 
const router = express.Router();


router.post("/createStore", verifyToken,checkUserIdentity, storeController.createStoreRequest);

router.put(
  "/approve/:storeId",
  { verifyToken, checkRole: "admin" },
  storeController.approveStore
);

router.put(
  "/approve-employee/:storeId",
    {verifyToken, checkRole: 'owner'},
  storeController.approveEmployee
);

router.put(
  "/update/:storeId",
  { verifyToken, checkRole: "owner" },
  storeController.updateStore
);

router.delete(
  "/delete/:storeId",
  { verifyToken, checkRole: "owner", checkRole: "admin" },
  storeController.deleteStore
);

router.get("/:storeId", storeController.getStoreById);
router.get("/", storeController.getAllStores);

module.exports = router;
