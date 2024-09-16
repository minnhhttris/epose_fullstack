const prisma = require("../../config/prismaClient");

class CommentService {
    async createComment(dataComment) {
        const comment = await prisma.comment.create({
        ...dataComment,
        });
        return comment;
    }
    
    async getCommentById(idComment) {
        return await prisma.comment.findUnique({
          where: { idComment: idComment },
        });
    }
    
    async updateComment(idComment, dataComment) {
        return prisma.comment.update({
        where: { idComment: idComment },
        dataComment,
        });
    }
    
    async deleteComment(idComment) {
        return prisma.comment.delete({
        where: { idComment: idComment },
        });
    }
}

module.exports = CommentService;