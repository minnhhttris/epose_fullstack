const express = require("express");
const router = express.Router();
const commentController = require("../../controllers/Comment/comment.controller");
const { verifyToken } = require("../../middlewares/verifyToken");

router.post("/:idPosts", verifyToken, commentController.createComment);

router.post("/:idPosts/:idComment", verifyToken, commentController.updateComment);

router.delete("/:idComment", verifyToken, commentController.deleteComment);

router.get("/:idPosts", commentController.getCommentsByPost);

module.exports = router;