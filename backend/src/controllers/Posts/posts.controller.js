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
      res.status(201).json(posts);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async getPosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const posts = await PostsService.getPostsById(idPosts);
      res.status(200).json({ success: true , posts });
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
      res.status(404).json({ error: "Posts not found" , success: false });
    }
  }

  async getAllPosts(req, res) {
    try {
      const posts = await PostsService.getAllPosts();
      res.status(200).json({
        success: true,
        posts
      });
    } catch (err) {
      res.status(404).json({ error: "Posts not found", success: false });
    }
  }

  async updatePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const dataPosts = req.body;
      const posts = await PostsService.updatePosts(idPosts, dataPosts);
      res.status(200).json(
        posts,
        { success: true }
      );
    } catch (err) {
      res.status(500).json({
        success: false,
        error: err.message
      });
    }
  }

  async deletePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      await PostsService.deletePosts(idPosts);
      res.status(200).json({
        success: true,
        message: "Posts deleted"
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
