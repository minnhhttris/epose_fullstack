const prisma = require("../../config/prismaClient");
const CLOUDINARY = require("../../config/cloudinaryConfig");

class ClothesStatusService {
  // Create a new clothes status for a specific bill
  async createClothesStatus(idBill, clothesStatusData) {
    try {
      let uploadedImages = [];

      // Upload images if provided
      if (clothesStatusData.images && clothesStatusData.images.length > 0) {
        uploadedImages = await Promise.all(
          clothesStatusData.images.map(async (image) => {
            if (image.startsWith("http")) {
              return image;
            } else {
              const uploadResult = await CLOUDINARY.uploader.upload(image.path);
              return uploadResult.secure_url;
            }
          })
        );
      }

      const newClothesStatus = await prisma.clothesStatus.create({
        data: {
          idBill: idBill,
          idBillItem: clothesStatusData.idBillItem,
          idItem: clothesStatusData.idItem,
          statusType: clothesStatusData.statusType,
          description: clothesStatusData.description,
          images: uploadedImages,
        },
      });

      return newClothesStatus;
    } catch (error) {
      throw new Error("Error creating clothes status: " + error.message);
    }
  }

  // Update an existing clothes status
  async updateClothesStatus(idStatus, clothesStatusData) {
    try {
      const existingStatus = await prisma.clothesStatus.findUnique({
        where: { idStatus },
      });

      if (!existingStatus) {
        throw new Error("Clothes status not found");
      }

      let uploadedImages = existingStatus.images || [];

      // Handle image updates
      if (clothesStatusData.images && clothesStatusData.images.length > 0) {
        uploadedImages = await Promise.all(
          clothesStatusData.images.map(async (image) => {
            if (image.startsWith("http")) {
              return image;
            } else {
              const uploadResult = await CLOUDINARY.uploader.upload(image.path);
              return uploadResult.secure_url;
            }
          })
        );
      }

      const updatedStatus = await prisma.clothesStatus.update({
        where: { idStatus },
        data: {
          statusType: clothesStatusData.statusType,
          description: clothesStatusData.description,
          images: uploadedImages,
        },
      });

      return updatedStatus;
    } catch (error) {
      throw new Error("Error updating clothes status: " + error.message);
    }
  }

  // Delete a clothes status
  async deleteClothesStatus(idStatus) {
    try {
      const deletedStatus = await prisma.clothesStatus.delete({
        where: { idStatus },
      });

      return deletedStatus;
    } catch (error) {
      throw new Error("Error deleting clothes status: " + error.message);
    }
  }

  // Get clothes statuses for a specific bill
  async getClothesStatusesByBill(idBill) {
    try {
      const statuses = await prisma.clothesStatus.findMany({
        where: { idBill },
        include: {
          billItem: {
            include: {
              clothes: true,
            },
          },
        },
      });

      return statuses;
    } catch (error) {
      throw new Error("Error fetching clothes statuses: " + error.message);
    }
  }

  // Get a specific clothes status by its ID
  async getClothesStatusById(idStatus) {
    try {
      const status = await prisma.clothesStatus.findUnique({
        where: { idStatus },
        include: {
          billItem: {
            include: {
              clothes: true,
            },
          },
        },
      });

      if (!status) {
        throw new Error("Clothes status not found");
      }

      return status;
    } catch (error) {
      throw new Error("Error fetching clothes status: " + error.message);
    }
  }

  async getClothesStatusByBillItem(idBillItem) {
    try {
      const statuses = await prisma.clothesStatus.findMany({
        where: { idBillItem },
        include: {
          billItem: {
            include: {
              clothes: true,
            },
          },
        },
      });

      if (!statuses || statuses.length === 0) {
        throw new Error("No clothes statuses found for the given Bill Item ID");
      }

      return statuses;
    } catch (error) {
      throw new Error(
        "Error fetching clothes statuses by Bill Item ID: " + error.message
      );
    }
  }
}

module.exports = new ClothesStatusService();
