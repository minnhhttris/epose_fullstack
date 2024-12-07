const ratingService = require("../../services/Rating/rating.service");

class RatingController {
  // Thêm đánh giá
  async addRating(req, res) {
    const idUser = req.user_id;
    const { idBill, idItem } = req.params;
    const { ratingstar, ratingcomment } = req.body;

    try {
      const rating = await ratingService.addRating(idUser, idBill, {
        idItem,
        ratingstar,
        ratingcomment,
      });

      return res.status(200).json({
        success: true,
        message: "Đánh giá đã được thêm thành công.",
        data: rating,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }

  // Cập nhật đánh giá
  async updateRating(req, res) {
    const idUser = req.user_id;
    const { idRating } = req.params;
    const { ratingstar, ratingcomment } = req.body;

    try {
      const updatedRating = await ratingService.updateRating(idRating, idUser, {
        ratingstar,
        ratingcomment,
      });

      return res.status(200).json({
        success: true,
        message: "Đánh giá đã được cập nhật thành công.",
        data: updatedRating,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }

  // Xóa đánh giá
  async deleteRating(req, res) {
    const idUser = req.user_id;
    const { idRating } = req.params;

    try {
      const deletedRating = await ratingService.deleteRating(idRating, idUser);

      return res.status(200).json({
        success: true,
        message: "Đánh giá đã được xóa thành công.",
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }

  // Lấy danh sách đánh giá theo idItem
  async getRatingsByItem(req, res) {
    const { idItem } = req.params;

    try {
      const ratings = await ratingService.getRatingsByItem(idItem);

      return res.status(200).json({
        success: true,
        data: ratings,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }

  // Lấy danh sách đánh giá theo idBill
  async getRatingsByBill(req, res) {
    const { idBill } = req.params;

    try {
      const ratings = await ratingService.getRatingsByBill(idBill);

      return res.status(200).json({
        success: true,
        data: ratings,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }
}

module.exports = new RatingController();
