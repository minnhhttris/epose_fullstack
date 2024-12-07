const prisma = require("../../config/prismaClient");

class CommentService {
  async createComment(idUser, idPosts, comment) {
    try {
      const postExists = await prisma.posts.findFirst({
        where: { idPosts },
      });

      if (!postExists) {
        throw new Error("Bài viết không tồn tại.");
      }

      const newComment = await prisma.comment.create({
        data: {
          idUser,
          idPosts,
          comment,
        },
      });
      return newComment;
    } catch (error) {
      throw new Error("Không thể tạo bình luận: " + error.message);
    }
  }

  // Cập nhật bình luận
  async updateComment(idUser, idPosts, idComment, comment) {
    try {
      const commentExists = await prisma.comment.findFirst({
        where: {
          idComment,
          idUser,
          idPosts,
        },
      });

      if (!commentExists) {
        throw new Error("Bình luận không tồn tại.");
      }

      const updatedComment = await prisma.comment.update({
        where: { idComment },
        data: comment,
      });
      return updatedComment;
    } catch (error) {
      throw new Error("Không thể cập nhật bình luận: " + error.message);
    }
  }

  // Xóa bình luận
  async deleteComment(idComment) {
    try {
      const updatedComment = await prisma.comment.update({
        where: { idComment },
        data: { isActive: false },
      });

      return { message: "Bình luận đã được xóa!" };
    } catch (error) {
      throw new Error("Không thể xóa bình luận: " + error.message);
    }
  }

  // Lấy bình luận theo idPosts
  async getCommentsByPost(idPosts) {
    try {
      const comments = await prisma.comment.findMany({
        where: {
          idPosts: idPosts,
          isActive: true, 
        },
        include: {
          user: true, 
        },
      });
      return comments;
    } catch (error) {
      throw new Error("Không thể lấy bình luận: " + error.message);
    }
  }
}

module.exports = new CommentService();