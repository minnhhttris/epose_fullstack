const express = require("express");
const router = express.Router();
const PostsController = require("../../controllers/posts.controller");
const { verifyToken } = require("../../middlewares/verifyToken");

router.post("/", verifyToken, PostsController.createPost);
router.get("/:id", PostsController.getPost);
router.put("/:id", verifyToken, PostsController.updatePost);
router.delete("/:id", verifyToken, PostsController.deletePost);
router.post("/:id/favorite", verifyToken, PostsController.favoritePost);
router.post("/:id/unfavorite", verifyToken, PostsController.unfavoritePost);

module.exports = router;
