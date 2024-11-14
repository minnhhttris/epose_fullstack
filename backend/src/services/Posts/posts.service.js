const prisma = require("../../config/prismaClient");
const CLOUDINARY = require("../../config/cloudinaryConfig");


class PostsService {
  async handleUploadedImages(dataPost) {
    let uploadedImages = [];
    if (dataPost.picture && dataPost.picture.length > 0) {
      uploadedImages = await Promise.all(
        dataPost.picture.map(async (image) => {
          if (image.startsWith("http")) {
            const uploadResult = await CLOUDINARY.uploader.upload(image);
            return uploadResult.secure_url;
          } else {
            const uploadResult = await CLOUDINARY.uploader.upload(image.path);
            return uploadResult.secure_url;
          }
        })
      );
    }
    return uploadedImages;
  }

  async createPosts(idUser, idStore, dataPosts) {
    try {
      let uploadedImages = [];
      if (dataPosts.picture && dataPosts.picture.length > 0) {
        uploadedImages = await Promise.all(
          dataPosts.picture.map(async (image) => {
            if (image.startsWith("http")) {
              const uploadResult = await CLOUDINARY.uploader.upload(image);
              return uploadResult.secure_url;
            } else {
              const uploadResult = await CLOUDINARY.uploader.upload(image.path);
              return uploadResult.secure_url;
            }
          })
        );
      }

      const newPost = await prisma.posts.create({
        data: {
          caption: dataPosts.caption,
          picture: uploadedImages,
          idUser: idUser,
          idStore: idStore,
        },
      });

      return newPost;
    } catch (error) {
      throw new Error("Error creating post: " + error.message);
    }
  }

  async getPostsById(id) {
    return await prisma.posts.findUnique({
      where: { idPosts: id },
      include: {
        comments: {
          include: {
            user: true, 
          },
        },
        favorites: true,
        store: true,
      },
    });
  }

  async getPostsByStore(idStore) {
    return await prisma.posts.findMany({
      where: { idStore },
      include: {
        comments: true,
        favorites: true,
        store: true,
      },
    });
  }

  async getAllPosts() {
    return await prisma.posts.findMany({
      include: {
        comments: {
          include: {
            user: true,
          },
        },
        favorites: true,
        store: true,
      },
    });
  }

  async updatePosts(idPosts, dataPosts) {
    try {
      const existingPost = await prisma.posts.findUnique({
        where: { idPosts },
      });

      if (!existingPost) {
        throw new Error("Post not found");
      }

      // Xóa các hình ảnh cũ trên Cloudinary nếu cần
      // if (existingPost.picture && existingPost.picture.length > 0) {
      //   await Promise.all(
      //     existingPost.picture.map(async (image) => {
      //       const publicId = image.split("/").pop().split(".")[0]; // Lấy public ID từ URL
      //       await CLOUDINARY.uploader.destroy(publicId); // Xóa hình ảnh trên Cloudinary
      //     })
      //   );
      // }

      let uploadedImages = [];
      if (dataPosts.picture && dataPosts.picture.length > 0) {
        uploadedImages = await Promise.all(
          dataPosts.picture.map(async (image) => {
            if (image.startsWith("http")) {
              const uploadResult = await CLOUDINARY.uploader.upload(image);
              return uploadResult.secure_url;
            } else {
              const uploadResult = await CLOUDINARY.uploader.upload(image.path);
              return uploadResult.secure_url;
            }
          })
        );
      }

      const updatedPost = await prisma.posts.update({
        where: { idPosts },
        data: {
          caption: dataPosts.caption || existingPost.caption,
          picture: uploadedImages,
        },
      });

      return updatedPost;
    } catch (error) {
      throw new Error("Error updating post: " + error.message);
    }
  }

  async deletePosts(idPosts) {
    try {
      const post = await prisma.posts.findUnique({
        where: { idPosts },
      });

      if (!post) {
        throw new Error("Post not found");
      }

      if (post.picture && post.picture.length > 0) {
        await Promise.all(
          post.picture.map(async (image) => {
            const publicId = image.split("/").pop().split(".")[0]; // Lấy public ID từ URL
            await CLOUDINARY.uploader.destroy(publicId); 
          })
        );
      }

      await prisma.favorite.deleteMany({
        where: { idPosts },
      });

      await prisma.comment.deleteMany({
        where: { idPosts },
      });

      const deletedPost = await prisma.posts.delete({
        where: { idPosts: idPosts },
      });

      return deletedPost;
    } catch (error) {
      throw new Error("Error deleting post: " + error.message);
    }
  }

  async favoritePosts(idUser, idPosts) {
    // Kiểm tra xem sở thích đã tồn tại chưa
    const existingFavorite = await prisma.favorite.findUnique({
      where: { idUser_idPosts: { idUser, idPosts } },
    });

    if (existingFavorite) {
      throw new Error("Post already favorited by this user.");
    }

    // Tạo sở thích mới
    const favorite = await prisma.favorite.create({
      data: { idUser, idPosts },
    });

    // Cập nhật số lượng sở thích của bài viết
    await prisma.posts.update({
      where: { idPosts },
      data: { favorite: { increment: 1 } },
    });

    return favorite;
  }

  async unfavoritePosts(idUser, idPosts) {
    // Kiểm tra xem sở thích có tồn tại không
    const existingFavorite = await prisma.favorite.findUnique({
      where: { idUser_idPosts: { idUser, idPosts } },
    });

    if (!existingFavorite) {
      throw new Error("No favorite found for this user.");
    }

    // Xóa sở thích
    await prisma.favorite.delete({
      where: { idUser_idPosts: { idUser, idPosts } },
    });

    // Cập nhật số lượng sở thích của bài viết
    await prisma.posts.update({
      where: { idPosts },
      data: { favorite: { decrement: 1 } },
    });
  }
}

module.exports = new PostsService();
