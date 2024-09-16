const prisma = require("../../config/prismaClient");

class PostsService {
  async createPosts(dataPost) {
    const posts = await prisma.posts.create({
      ...dataPost,
    });
    return posts;
  }

  async getPostsById(id) {
    return await prisma.posts.findUnique({
      where: { idPosts: id },
      include: {
        comments: true,
        favorites: true,
      },
    });
  }

  async updatePosts(idPosts, dataPosts) {
    return prisma.posts.update({
      where: { idPosts: idPosts },
      dataPosts,
    });
  }

  async deletePosts(idPosts) {
    await prisma.favorite.deleteMany({
      where: { idPosts },
    });
    await prisma.comment.deleteMany({
      where: { idPosts },
    });
    return prisma.posts.delete({
      where: { idPosts: idPosts },
    });
  }

  async favoritePosts(idUser, idPosts) {
    const favorite = await prisma.favorite.create({
      data: { idUser, idPosts: idPosts },
    });
    await prisma.posts.update({
      where: { idPosts: idPosts },
      data: { favorite: { increment: 1 } },
    });
    return favorite;
  }

  async unfavoritePosts(idUser, idPost) {
    await prisma.favorite.delete({
      where: { idUser_idPosts: { idUser, idPosts: idPost } },
    });
    await prisma.posts.update({
      where: { idPosts: idPost },
      data: { favorite: { decrement: 1 } },
    });
  }
}

module.exports = new PostsService();
