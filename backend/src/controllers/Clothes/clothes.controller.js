const ClothesService = require("../../services/Clothes/clothes.service");
const CLOUDINARY = require("../../config/cloudinaryConfig");

class ClothesController {
  async createClothes(req, res) {
    try {
      const idStore = req.params.idStore;
      const clothesData = req.body;

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
      if (clothesData.listPicture && clothesData.listPicture.length > 0) {
        const urlUploads = await Promise.all(
          clothesData.listPicture.map(async (imageUrl) => {
            if (imageUrl.startsWith("http")) {
              const uploadResult = await CLOUDINARY.uploader.upload(imageUrl);
              return uploadResult.secure_url;
            }
          })
        );
        uploadedImages = uploadedImages.concat(urlUploads);
      }

      clothesData.listPicture = uploadedImages;

      if (typeof clothesData.itemSizes === "string") {
        clothesData.itemSizes = JSON.parse(clothesData.itemSizes);
      }

      // Kiểm tra nếu itemSizes không phải là mảng hợp lệ
      if (!Array.isArray(clothesData.itemSizes)) {
        return res.status(400).json({
          success: false,
          message: "itemSizes phải là một mảng hợp lệ.",
        });
      }

      clothesData.price = parseFloat(clothesData.price);

      const clothes = await ClothesService.createClothes(idStore, clothesData);

      return res.status(201).json({
        success: true,
        message: "Quần áo đã được tạo thành công!",
        data: clothes,
      });
    } catch (error) {
      console.error("Error in createClothes:", error);
      return res.status(500).json({
        success: false,
        message: "Không thể tạo quần áo.",
        error: error.message,
      });
    }
  }

  async updateClothes(req, res) {
    try {
      const idItem = req.params.idItem;
      const clothesData = req.body;

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
      if (clothesData.listPicture && clothesData.listPicture.length > 0) {
        const urlUploads = await Promise.all(
          clothesData.listPicture.map(async (imageUrl) => {
            if (imageUrl.startsWith("http")) {
              const uploadResult = await CLOUDINARY.uploader.upload(imageUrl);
              return uploadResult.secure_url;
            }
          })
        );
        uploadedImages = uploadedImages.concat(urlUploads);
      }

      clothesData.listPicture = uploadedImages;

      if (typeof clothesData.itemSizes === "string") {
        clothesData.itemSizes = JSON.parse(clothesData.itemSizes);
      }

      if (!Array.isArray(clothesData.itemSizes)) {
        return res.status(400).json({
          success: false,
          message: "itemSizes phải là một mảng hợp lệ.",
        });
      }

      clothesData.price = parseFloat(clothesData.price);

      const updatedClothes = await ClothesService.updateClothes(
        idItem,
        clothesData
      );

      return res.status(200).json({
        success: true,
        message: "Quần áo đã được cập nhật thành công!",
        data: updatedClothes,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
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
        success: true,
        message: "Quần áo đã được xóa thành công!",
        data: deletedClothes,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
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
        success: true,
        message: "Lấy thông tin quần áo thành công!",
        data: clothes,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
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
        success: true,
        message: "Lấy thông tin quần áo thành công!",
        data: clothes,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể lấy thông tin quần áo.",
        error: error.message,
      });
    }
  }

  async getAllClothes(req, res) {
    try {
      const clothesData = await ClothesService.getAllClothes();
      return res.status(200).json({
        success: true,
        message: "Lấy danh sách quần áo thành công!",
        data: clothesData,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể lấy danh sách quần áo.",
        error: error.message,
      });
    }
  }

  async updateClothesQuantity(req, res) {
    try {
      const idItem = req.params.idItem;
      const { size, quantityChange } = req.body;
      const updatedClothes = await ClothesService.updateClothesQuantity(
        idItem,
        size,
        quantityChange
      );

      return res.status(200).json({
        success: true,
        message: "Cập nhật số lượng quần áo thành công!",
        data: updatedClothes,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể cập nhật số lượng quần áo.",
        error: error.message,
      });
    }
  }

}



module.exports = new ClothesController();
