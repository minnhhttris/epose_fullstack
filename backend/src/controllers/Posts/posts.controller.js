const PostsService = require("../../services/Posts/posts.service");

class PostsController {
  async createPosts(req, res) {
    try {
      const posts = await PostsService.createPosts(req.body);
      res.status(201).json(posts);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async getPosts(req, res) {
    try {
      const posts = await PostsService.getPostsById(req.params.id);
      res.status(200).json(posts);
    } catch (err) {
      res.status(404).json({ error: "Posts not found" });
    }
  }

  async updatePosts(req, res) {
    try {
      const posts = await PostsService.updatePosts(req.params.id, req.body);
      res.status(200).json(posts);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async deletePosts(req, res) {
    try {
      await PostsService.deletePosts(req.params.id);
      res.status(200).json({ message: "Posts deleted" });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async favoritePosts(req, res) {
    try {
      const favorite = await PostsService.favoritePosts(
        req.body.idUser,
        req.params.id
      );
      res.status(200).json(favorite);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }

  async unfavoritePosts(req, res) {
    try {
      await PostsService.unfavoritePosts(req.body.idUser, req.params.id);
      res.status(200).json({ message: "Unfavorited posts" });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }
}

module.exports = new PostsController();
