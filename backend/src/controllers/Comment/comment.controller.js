const commentService = require("../../services/Comment/comment.service");

class CommentController {
  // Tạo bình luận
  async createComment(req, res) {
    const idUser = req.user_id;
    const { idPosts } = req.params;
    const dataComment = req.body;
    const comment = dataComment.comment;
    try {
      const newComment = await commentService.createComment(
        idUser,
        idPosts,
        comment
      );
      return res.status(201).json({
        success: true,
        message: "Bình luận đã được tạo thành công!",
        data: newComment,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể tạo bình luận!",
        error: error.message,
      });
    }
  }

  // Cập nhật bình luận
  async updateComment(req, res) {
    const idUser = req.user_id;
    const { idPosts, idComment } = req.params;
    const comment = req.body;
    try {
        const updatedComment = await commentService.updateComment(
          idUser,
          idPosts,
          idComment,
          comment
        );
      return res.status(200).json({
        success: true,
        message: "Bình luận đã được cập nhật!",
        data: updatedComment,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể cập nhật bình luận!",
        error: error.message,
      });
    }
  }

  // Xóa bình luận
  async deleteComment(req, res) {
    const { idComment } = req.params;

    try {
      const response = await commentService.deleteComment(idComment);
      return res.status(200).json({
        success: true,
        message: "Bình luận đã được xóa thành công!",
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể xóa bình luận!",
        error: error.message,
      });
    }
  }

  // Lấy bình luận theo idPosts
  async getCommentsByPost(req, res) {
    const { idPosts } = req.params;

    try {
      const comments = await commentService.getCommentsByPost(idPosts);
      return res.status(200).json({
        success: true,
        data: comments,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể lấy bình luận!",
        error: error.message,
      });
    }
  }
}

module.exports = new CommentController();
