const express = require('express');
const storeController = require('../../controllers/Store/store.controller');
const { verifyToken } = require('../../middlewares/verifyToken');
const checkUserIdentity = require('../../middlewares/checkUserIdentity'); 
const router = express.Router();
const authorizeRoles = require('../../middlewares/authorizeRoles');


router.post(
  "/createStore",
  verifyToken,
  checkUserIdentity,
  authorizeRoles('user'),
  storeController.createStore
);

router.put(
  "/approve/:storeId",
  verifyToken, authorizeRoles("admin") ,
  storeController.approveStore
);

router.put(
  "/approve-employee/:storeId",
  verifyToken,
  authorizeRoles("owner"),
  storeController.approveEmployee
);

router.put(
  "/update/:storeId",
  verifyToken, authorizeRoles("owner"),
  storeController.updateStore
);

router.delete(
  "/delete/:storeId",
  verifyToken, authorizeRoles("owner", "admin"),
  storeController.deleteStore
);

router.get("/:storeId", storeController.getStoreById);
router.get("/", storeController.getAllStores);

module.exports = router;
