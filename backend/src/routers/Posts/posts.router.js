const express = require("express");
const router = express.Router();
const PostsController = require("../../controllers/Posts/posts.controller");
const { verifyToken } = require("../../middlewares/verifyToken");

router.post("/", verifyToken, PostsController.createPosts);
router.get("/:id", PostsController.getPosts);
router.put("/:id", verifyToken, PostsController.updatePost);
router.delete("/:id", verifyToken, PostsController.deletePost);
router.post("/:id/favorite", verifyToken, PostsController.favoritePost);
router.post("/:id/unfavorite", verifyToken, PostsController.unfavoritePost);

module.exports = router;
