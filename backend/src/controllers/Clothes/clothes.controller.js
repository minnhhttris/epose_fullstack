const ClothesService = require("../../services/Clothes/clothes.service");

class ClothesController {
  async createClothes(req, res) {
    try {
      const idStore = req.params.idStore;
      const clothes = await ClothesService.createClothes(idStore, req.body);
      return res.status(201).json({
        message: "Đã tạo sản phẩm!",
        data: clothes,
      });
    } catch (error) {
      return res.status(400).json({
        message: "Không thể tạo sản phẩm. Vui lòng thử lại.",
        error: error.message,
      });
    }
  }

  async updateClothes(req, res) {
    try {
      const { idItem } = req.params;
      const clothes = await ClothesService.updateClothes(idItem, req.body);
      return res.status(200).json({
        message: "Đã cập nhật sản phẩm!",
        data: clothes,
      });
    } catch (error) {
      return res.status(400).json({
        message:
          "Không thể cập nhật sản phẩm. Vui lòng kiểm tra thông tin và thử lại.",
        error: error.message,
      });
    }
  }

  async getClothesByStore(req, res) {
    try {
      const { idStore } = req.params;
      const clothes = await ClothesService.getClothesByStore(idStore);
      return res.status(200).json({
        message: "Đã lấy thông tin sản phẩm theo cửa hàng!",
        data: clothes,
      });
    } catch (error) {
      return res.status(404).json({
        message: "Không tìm thấy sản phẩm nào.",
        error: error.message,
      });
    }
  }

  async getClothesById(req, res) {
    try {
      const { idItem } = req.params;
      const clothes = await ClothesService.getClothesById(idItem);
      return res.status(200).json({
        message: "Đã lấy thông tin sản phẩm!",
        data: clothes,
      });
    } catch (error) {
      return res.status(404).json({
        message: "Không tìm thấy sản phẩm với ID đã cung cấp.",
        error: error.message,
      });
    }
  }

  async getAllClothes(req, res) {
    try {
      const clothes = await ClothesService.getAllClothes();
      return res.status(200).json({
        message: "Đã lấy thông tin tất cả sản phẩm!",
        data: clothes,
      });
    } catch (error) {
      return res.status(404).json({
        message: "Không tìm thấy sản phẩm nào.",
        error: error.message,
      });
    }
  }

  async deleteClothes(req, res) {
    try {
      const { idItem } = req.params;
      await ClothesService.deleteClothes(idItem);
      return res.status(204).json({
        message: "Đã xóa sản phẩm!",
      });
    } catch (error) {
      return res.status(400).json({
        message: "Không thể xóa sản phẩm. Vui lòng thử lại.",
        error: error.message,
      });
    }
  }
}

module.exports = new ClothesController();
