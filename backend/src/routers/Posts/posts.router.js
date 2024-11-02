const express = require("express");
const router = express.Router();
const postsController = require("../../controllers/Posts/posts.controller");
const { verifyToken } = require("../../middlewares/verifyToken");
const upload = require("../../config/multerConfig");
const authorizeRoles = require("../../middlewares/authorizeRoles");

router.post(
  "/store/:idStore/createPosts",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  upload.uploadPostImages,
  postsController.createPosts
);

router.post(
  "/:idPosts",
  verifyToken,
  authorizeRoles("admin", "owner", "employee"),
  upload.uploadPostImages,
  postsController.updatePosts
);
router.delete("/:idPosts", verifyToken, postsController.deletePosts);

router.get("/:idPosts", postsController.getPosts);
router.get("/store/:idStore/", verifyToken, postsController.getPostsByStore);
router.get("/", postsController.getAllPosts);

router.post("/:idPosts/favorite", verifyToken, postsController.favoritePosts);
router.post("/:idPosts/unfavorite", verifyToken, postsController.unfavoritePosts);

module.exports = router;
