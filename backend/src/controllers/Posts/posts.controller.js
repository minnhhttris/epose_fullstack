const PostsService = require("../../services/Posts/posts.service");
const CLOUDINARY = require("../../config/cloudinaryConfig");

class PostsController {
  async createPosts(req, res) {
    try {
      const idUser = req.user_id;
      const idStore = req.params.idStore;
      const dataPost = req.body;

      let uploadedImages = [];

      if (req.files && req.files.length > 0) {
        const fileUploads = await Promise.all(
          req.files.map(async (file) => {
            const uploadResult = await CLOUDINARY.uploader.upload(file.path);
            return uploadResult.secure_url;
          })
        );
        uploadedImages = uploadedImages.concat(fileUploads);
      }

      // Upload ảnh từ URL (nếu có)
      if (dataPost.picture && dataPost.picture.length > 0) {
        const urlUploads = await Promise.all(
          dataPost.picture.map(async (imageUrl) => {
            if (imageUrl.startsWith("http")) {
              const uploadResult = await CLOUDINARY.uploader.upload(imageUrl);
              return uploadResult.secure_url;
            }
          })
        );
        uploadedImages = uploadedImages.concat(urlUploads);
      }

      dataPost.picture = uploadedImages;

      const posts = await PostsService.createPosts(idUser, idStore, dataPost);
      return res.status(201).json({
        success: true,
        message: "Bài viết đã được tạo thành công!",
        data: posts,
      });
    } catch (err) {
      return res.status(500).json({
        success: false,
        message: "Không thể tạo bài viết!",
        error: err.message,
      });
    }
  }

  async getPosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const posts = await PostsService.getPostsById(idPosts);
      res.status(200).json({ success: true, posts });
    } catch (err) {
      res.status(404).json({ error: "Posts not found", success: false });
    }
  }

  async getPostsByStore(req, res) {
    try {
      const idStore = req.params.idStore;
      const posts = await PostsService.getPostsByStore(idStore);
      res.status(200).json({ success: true, posts });
    } catch (err) {
      res.status(404).json({ error: "Posts not found", success: false });
    }
  }

  async getAllPosts(req, res) {
    try {
      const posts = await PostsService.getAllPosts();
      res.status(200).json({
        success: true,
        posts,
      });
    } catch (err) {
      res.status(404).json({ error: "Posts not found", success: false });
    }
  }

  async updatePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const dataPost = req.body;

      console.log("Received idPosts:", idPosts);
      console.log("Received dataPost:", dataPost);

      let uploadedImages = [];

      // Parse picture string into an array if needed
      if (
        dataPost.picture === null ||
        dataPost.picture === "null" ||
        dataPost.picture === ""
      ) {
        dataPost.picture = [];
      } else if (typeof dataPost.picture === "string") {
        dataPost.picture = dataPost.picture.split(",");
      }

      // Handle files from req.files
      if (req.files && req.files.length > 0) {
        const fileUploads = await Promise.all(
          req.files.map(async (file) => {
            if (file.path.startsWith("http")) {
              console.log("File already uploaded to Cloudinary:", file.path);
              return file.path;
            } else {
              console.log("Uploading file to Cloudinary:", file.path);
              const uploadResult = await CLOUDINARY.uploader.upload(file.path);
              return uploadResult.secure_url;
            }
          })
        );
        uploadedImages = uploadedImages.concat(fileUploads);
      }

      // Handle URLs in dataPost.picture
      if (dataPost.picture && Array.isArray(dataPost.picture)) {
        const urlUploads = await Promise.all(
          dataPost.picture.map(async (imageUrl) => {
            if (imageUrl.startsWith("http")) {
              return imageUrl; // Use the existing URL
            } else {
              console.log(
                "Uploading additional image to Cloudinary:",
                imageUrl
              );
              const uploadResult = await CLOUDINARY.uploader.upload(imageUrl);
              return uploadResult.secure_url;
            }
          })
        );
        uploadedImages = uploadedImages.concat(urlUploads);
      }

      dataPost.picture = uploadedImages;

      console.log("Final uploaded images:", uploadedImages);

      const posts = await PostsService.updatePosts(idPosts, dataPost);
      return res.status(201).json({
        success: true,
        message: "Bài viết đã được cập nhật thành công!",
        data: posts,
      });
    } catch (err) {
      console.error("Error updating post:", err.message);
      res.status(500).json({
        success: false,
        error: err.message,
        message: "Không thể cập nhật bài viết!",
      });
    }
  }

  async deletePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      await PostsService.deletePosts(idPosts);
      res.status(200).json({
        success: true,
        message: "Posts deleted",
      });
    } catch (err) {
      res.status(500).json({
        success: false,
        error: err.message,
      });
    }
  }

  async favoritePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const idUser = req.user_id;
      await PostsService.favoritePosts(idUser, idPosts);
      res.status(200).json({
        success: true,
        message: "Unfavorited posts",
      });
    } catch (err) {
      res.status(500).json({
        success: false,
        error: err.message,
      });
    }
  }

  async unfavoritePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const idUser = req.user_id;
      await PostsService.unfavoritePosts(idUser, idPosts);
      res.status(200).json({
        message: "Unfavorited posts",
        success: true,
      });
    } catch (err) {
      res.status(500).json({
        success: false,
        error: err.message,
      });
    }
  }
}

module.exports = new PostsController();
