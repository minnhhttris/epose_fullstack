const ClothesService = require("../../services/Clothes/clothes.service");

class ClothesController {
  async createClothes(req, res) {
    try {
      const idStore = req.params.idStore;
      const clothesData = req.body;
      const newClothes = await ClothesService.createClothes(
        idStore,
        clothesData
      );

      return res.status(201).json({
        message: "Quần áo đã được tạo thành công!",
        data: newClothes,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể tạo quần áo.",
        error: error.message,
      });
    }
  }

  async updateClothes(req, res) {
    try {
      const idItem = req.params.idItem;
      const updateData = req.body;
      const updatedClothes = await ClothesService.updateClothes(
        idItem,
        updateData
      );

      return res.status(200).json({
        message: "Quần áo đã được cập nhật thành công!",
        data: updatedClothes,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể cập nhật quần áo.",
        error: error.message,
      });
    }
  }

  async deleteClothes(req, res) {
    try {
      const idItem = req.params.idItem;
      const deletedClothes = await ClothesService.deleteClothes(idItem);

      return res.status(200).json({
        message: "Quần áo đã được xóa thành công!",
        data: deletedClothes,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể xóa quần áo.",
        error: error.message,
      });
    }
  }

  async getClothesById(req, res) {
    try {
      const idItem = req.params.idItem; 
      const clothes = await ClothesService.getClothesById(idItem);

      if (!clothes) {
        return res.status(404).json({ message: "Quần áo không tồn tại." });
      }

      return res.status(200).json({
        message: "Lấy thông tin quần áo thành công!",
        data: clothes,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể lấy thông tin quần áo.",
        error: error.message,
      });
    }
  }

  async getClothesByStore(req, res) {
    try {
      const idStore = req.params.idStore;
      const clothes = await ClothesService.getClothesByStore(idStore);

      return res.status(200).json({
        message: "Lấy thông tin quần áo thành công!",
        data: clothes,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể lấy thông tin quần áo.",
        error: error.message,
      });
    }
  }

  async searchClothes(req, res) {
    try {
      const searchCriteria = req.body;

      if (!searchCriteria || !searchCriteria.query) {
        return res.status(400).json({
          message: "Vui lòng cung cấp tiêu chí tìm kiếm.",
        });
      }

      const clothes = await ClothesService.searchClothes(searchCriteria.query);

      // Quản lý trường hợp không tìm thấy
      if (clothes.length === 0) {
        return res.status(404).json({
          message: "Không tìm thấy quần áo nào phù hợp với tiêu chí tìm kiếm.",
        });
      }

      return res.status(200).json({
        message: "Kết quả tìm kiếm quần áo!",
        data: clothes,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể tìm kiếm quần áo.",
        error: error.message,
      });
    }
  }

  async getAllClothes(req, res) {
    try {
      const clothesData = await ClothesService.getAllClothes();
      return res.status(200).json({
        message: "Lấy danh sách quần áo thành công!",
        data: clothesData,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể lấy danh sách quần áo.",
        error: error.message,
      });
    }
  }

  async getClothesByStyle(req, res) {
    try {
      const style = req.body.style;
      const clothesData = await ClothesService.getClothesByStyle(style);

      return res.status(200).json({
        message: "Lấy danh sách quần áo theo phong cách thành công!",
        data: clothesData,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể lấy danh sách quần áo theo phong cách.",
        error: error.message,
      });
    }
  }

  async getClothesByColor(req, res) {
    try {
      const color = req.body.color;
      const clothesData = await ClothesService.getClothesByColor(color);

      return res.status(200).json({
        message: "Lấy danh sách quần áo theo màu sắc thành công!",
        data: clothesData,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể lấy danh sách quần áo theo màu sắc.",
        error: error.message,
      });
    }
  }

  async getClothesByGender(req, res) {
    try {
      const gender = req.body.gender;
      const clothesData = await ClothesService.getClothesByGender(gender);

      return res.status(200).json({
        message: "Lấy danh sách quần áo theo giới tính thành công!",
        data: clothesData,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể lấy danh sách quần áo theo giới tính.",
        error: error.message,
      });
    }
  }

  async get10NewClothes(req, res) {
    try {
      const clothesData = await ClothesService.get10NewClothes();
      return res.status(200).json({
        message: "Lấy danh sách 10 quần áo mới nhất thành công!",
        data: clothesData,
      });
    } catch (error) {
      return res.status(500).json({
        message: "Không thể lấy danh sách 10 quần áo mới nhất.",
        error: error.message,
      });
    }
  }

}



module.exports = new ClothesController();
