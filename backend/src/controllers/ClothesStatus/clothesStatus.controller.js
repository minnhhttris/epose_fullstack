const ClothesStatusService = require("../../services/ClothesStatus/clothesStatus.service");
const CLOUDINARY = require("../../config/cloudinaryConfig");

class ClothesStatusController {
  // Tạo trạng thái quần áo mới
  async createClothesStatus(req, res) {
    try {
      const idBill = req.params.idBill;
      const clothesStatusData = req.body;

      let uploadedImages = [];

      // Upload hình ảnh từ file
      if (req.files && req.files.length > 0) {
        const fileUploads = await Promise.all(
          req.files.map(async (file) => {
            const uploadResult = await CLOUDINARY.uploader.upload(file.path);
            return uploadResult.secure_url;
          })
        );
        uploadedImages = uploadedImages.concat(fileUploads);
      }

      // Upload hình ảnh từ URL
      if (clothesStatusData.images && clothesStatusData.images.length > 0) {
        const urlUploads = await Promise.all(
          clothesStatusData.images.map(async (imageUrl) => {
            if (imageUrl.startsWith("http")) {
              return imageUrl;
            } else {
              const uploadResult = await CLOUDINARY.uploader.upload(imageUrl);
              return uploadResult.secure_url;
            }
          })
        );
        uploadedImages = uploadedImages.concat(urlUploads);
      }

      clothesStatusData.images = uploadedImages;

      const newStatus = await ClothesStatusService.createClothesStatus(
        idBill,
        clothesStatusData
      );

      return res.status(201).json({
        success: true,
        message: "Trạng thái quần áo đã được tạo thành công!",
        data: newStatus,
      });
    } catch (error) {
      console.error("Error in createClothesStatus:", error);
      return res.status(500).json({
        success: false,
        message: "Không thể tạo trạng thái quần áo.",
        error: error.message,
      });
    }
  }

  // Cập nhật trạng thái quần áo
  async updateClothesStatus(req, res) {
    try {
      const idStatus = req.params.idStatus;
      const clothesStatusData = req.body;

      let uploadedImages = [];

      // Upload hình ảnh từ file
      if (req.files && req.files.length > 0) {
        const fileUploads = await Promise.all(
          req.files.map(async (file) => {
            const uploadResult = await CLOUDINARY.uploader.upload(file.path);
            return uploadResult.secure_url;
          })
        );
        uploadedImages = uploadedImages.concat(fileUploads);
      }

      // Upload hình ảnh từ URL
      if (clothesStatusData.images && clothesStatusData.images.length > 0) {
        const urlUploads = await Promise.all(
          clothesStatusData.images.map(async (imageUrl) => {
            if (imageUrl.startsWith("http")) {
              return imageUrl;
            } else {
              const uploadResult = await CLOUDINARY.uploader.upload(imageUrl);
              return uploadResult.secure_url;
            }
          })
        );
        uploadedImages = uploadedImages.concat(urlUploads);
      }

      clothesStatusData.images = uploadedImages;

      const updatedStatus = await ClothesStatusService.updateClothesStatus(
        idStatus,
        clothesStatusData
      );

      return res.status(200).json({
        success: true,
        message: "Trạng thái quần áo đã được cập nhật thành công!",
        data: updatedStatus,
      });
    } catch (error) {
      console.error("Error in updateClothesStatus:", error);
      return res.status(500).json({
        success: false,
        message: "Không thể cập nhật trạng thái quần áo.",
        error: error.message,
      });
    }
  }

  // Xóa trạng thái quần áo
  async deleteClothesStatus(req, res) {
    try {
      const idStatus = req.params.idStatus;
      const deletedStatus = await ClothesStatusService.deleteClothesStatus(
        idStatus
      );

      return res.status(200).json({
        success: true,
        message: "Trạng thái quần áo đã được xóa thành công!",
        data: deletedStatus,
      });
    } catch (error) {
      console.error("Error in deleteClothesStatus:", error);
      return res.status(500).json({
        success: false,
        message: "Không thể xóa trạng thái quần áo.",
        error: error.message,
      });
    }
  }

  // Lấy trạng thái quần áo theo idBill
  async getClothesStatusesByBill(req, res) {
    try {
      const idBill = req.params.idBill;
      const statuses = await ClothesStatusService.getClothesStatusesByBill(
        idBill
      );

      return res.status(200).json({
        success: true,
        message: "Lấy danh sách trạng thái quần áo thành công!",
        data: statuses,
      });
    } catch (error) {
      console.error("Error in getClothesStatusesByBill:", error);
      return res.status(500).json({
        success: false,
        message: "Không thể lấy danh sách trạng thái quần áo.",
        error: error.message,
      });
    }
  }

  // Lấy trạng thái quần áo theo idBillItem
  async getClothesStatusByBillItem(req, res) {
    try {
      const idBillItem = req.params.idBillItem;
      const statuses = await ClothesStatusService.getClothesStatusByBillItem(
        idBillItem
      );

      return res.status(200).json({
        success: true,
        message: "Lấy trạng thái quần áo thành công!",
        data: statuses,
      });
    } catch (error) {
      console.error("Error in getClothesStatusByBillItem:", error);
      return res.status(500).json({
        success: false,
        message: "Không thể lấy trạng thái quần áo.",
        error: error.message,
      });
    }
  }
}

module.exports = new ClothesStatusController();
