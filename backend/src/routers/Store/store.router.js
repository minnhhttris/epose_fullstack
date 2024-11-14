const express = require('express');
const storeController = require('../../controllers/Store/store.controller');
const { verifyToken } = require('../../middlewares/verifyToken');
const checkUserIdentity = require('../../middlewares/checkUserIdentity'); 
const router = express.Router();
const authorizeRoles = require('../../middlewares/authorizeRoles');
const upload = require("../../config/multerConfig");


router.post(
  "/createStore",
  verifyToken,
  checkUserIdentity,
  authorizeRoles("user"),
  upload.uploadLogo,
  storeController.createStore
);

router.post(
  "/approveStore",
  verifyToken,
  authorizeRoles("admin"),
  storeController.approveStore
);

router.put(
  "/approve-employee",
  verifyToken,
  authorizeRoles("owner"),
  storeController.approveEmployee
);

router.put(
  "/updateStore",
  verifyToken, authorizeRoles("owner", "admin"),
  storeController.updateStore
);

router.delete(
  "/deleteStore",
  verifyToken, authorizeRoles("owner", "admin"),
  storeController.deleteStore
);

router.get("/:idStore", storeController.getStoreById);
router.get("/getStore", verifyToken, authorizeRoles("owner", "employee"), storeController.getStoreByIdUserLogin);
router.get("/user/:idUser", storeController.getStoreByIdUser);
router.get("/", storeController.getAllStores);

module.exports = router;
