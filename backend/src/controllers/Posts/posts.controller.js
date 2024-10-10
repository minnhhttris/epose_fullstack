const PostsService = require("../../services/Posts/posts.service");

class PostsController {
  async createPosts(req, res) {
    try {
      const idUser = req.user_id;
      const idStore = req.params.idStore;
      const dataPost = req.body;
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
      res.status(200).json(posts);
    } catch (err) {
      res.status(404).json({ error: "Posts not found" });
    }
  }

  async getPostsByStore(req, res) {
    try {
      const idStore = req.params.idStore;
      const posts = await PostsService.getPostsByStore(idStore);
      res.status(200).json(posts);
    } catch (err) {
      res.status(404).json({ error: "Posts not found" });
    }
  }

  async getAllPosts(req, res) {
    try {
      const posts = await PostsService.getAllPosts();
      res.status(200).json(posts);
    } catch (err) {
      res.status(404).json({ error: "Posts not found" });
    }
  }

  async updatePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const dataPosts = req.body;
      const posts = await PostsService.updatePosts(idPosts, dataPosts);
      res.status(200).json(posts);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async deletePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      await PostsService.deletePosts(idPosts);
      res.status(200).json({ message: "Posts deleted" });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async favoritePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const idUser = req.user_id;
      const favorite = await PostsService.favoritePosts(idUser, idPosts);
      res.status(200).json(favorite);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async unfavoritePosts(req, res) {
    try {
      const idPosts = req.params.idPosts;
      const idUser = req.user_id;
      await PostsService.unfavoritePosts(idUser, idPosts);
      res.status(200).json({ message: "Unfavorited posts" });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }
}

module.exports = new PostsController();
