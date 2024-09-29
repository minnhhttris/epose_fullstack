const prisma = require("../../config/prismaClient");


class PostsService {
  async handleUploadedImages(dataPost) {
    let uploadedImages = [];
    if (dataPost.IMAGES && dataPost.IMAGES.length > 0) {
      uploadedImages = await Promise.all(
        dataPost.IMAGES.map(async (image) => {
          if (image.startsWith("http")) {
            const uploadResult = await CLOUDINARY.uploader.upload(image);
            return uploadResult.secure_url;
          } else {
            const uploadResult = await CLOUDINARY.uploader.upload(
              image.path
            );
            return uploadResult.secure_url;
          }
        })
      );
    }
    return uploadedImages;
  }
        

  async createPosts(dataPost) {
    const posts = await prisma.posts.create({
      data: dataPost,
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
