const prisma = require("../../config/prismaClient");
const CLOUDINARY = require("../../config/cloudinaryConfig");

class ClothesService {
  async createClothes(idStore, clothesData) {
    try {
      let uploadedImages = [];

      if (clothesData.listPicture && clothesData.listPicture.length > 0) {
        uploadedImages = await Promise.all(
          clothesData.listPicture.map(async (image) => {
            if (typeof image === "string" && image.startsWith("http")) {
              const uploadResult = await CLOUDINARY.uploader.upload(image);
              return uploadResult.secure_url;
            } else if (image.path) {
              const uploadResult = await CLOUDINARY.uploader.upload(image.path);
              return uploadResult.secure_url;
            }
          })
        );
      }

      const totalQuantity = clothesData.itemSizes.reduce(
        (sum, size) => sum + size.quantity,
        0
      );

      const newClothes = await prisma.clothes.create({
        data: {
          nameItem: clothesData.nameItem,
          description: clothesData.description,
          price: clothesData.price,
          listPicture: uploadedImages,
          rate: clothesData.rate,
          favorite: clothesData.favorite,
          color: clothesData.color,
          style: clothesData.style,
          gender: clothesData.gender,
          number: totalQuantity,
          idStore: idStore,
          itemSizes: {
            createMany: {
              data: clothesData.itemSizes.map((size) => ({
                size: size.size,
                quantity: size.quantity,
              })),
            },
          },
        },
        include: {
          itemSizes: true,
        },
      });

      return newClothes;
    } catch (error) {
      throw new Error("Error creating clothes: " + error.message);
    }
  }

  async updateClothes(idItem, clothesData) {
    try {
      const existingClothes = await prisma.clothes.findUnique({
        where: { idItem },
        include: {
          itemSizes: true,
        },
      });

      if (!existingClothes) {
        throw new Error("Post not found");
      }

      let uploadedImages = [];
      if (clothesData.listPicture && clothesData.listPicture.length > 0) {
        await Promise.all(
          existingClothes.listPicture.map(async (image) => {
            const publicId = image.split("/").pop().split(".")[0]; // Lấy public ID từ URL
            await CLOUDINARY.uploader.destroy(publicId); // Xóa hình ảnh trên Cloudinary
          })
        );

        uploadedImages = await Promise.all(
          clothesData.listPicture.map(async (image) => {
            if (image.startsWith("http")) {
              const uploadResult = await CLOUDINARY.uploader.upload(image);
              return uploadResult.secure_url;
            } else {
              const uploadResult = await CLOUDINARY.uploader.upload(image.path);
              return uploadResult.secure_url;
            }
          })
        );
      }

      if (clothesData.itemSizes && clothesData.itemSizes.length > 0) {
        await prisma.itemSizes.deleteMany({
          where: { idItem },
        });

        await prisma.itemSizes.createMany({
          data: clothesData.itemSizes.map((size) => ({
            idItem,
            size: size.size,
            quantity: size.quantity,
          })),
        });
      }

      await prisma.clothes.update({
        where: { idItem },
        data: {
          nameItem: clothesData.nameItem || existingClothes.nameItem,
          description: clothesData.description || existingClothes.description,
          price: clothesData.price || existingClothes.price,
          listPicture:
            uploadedImages.length > 0
              ? uploadedImages
              : existingClothes.listPicture,
          rate: clothesData.rate || existingClothes.rate,
          favorite: clothesData.favorite || existingClothes.favorite,
          color: clothesData.color || existingClothes.color,
          style: clothesData.style || existingClothes.style,
        },
      });

      const updatedClothes = await prisma.clothes.findUnique({
        where: { idItem },
        include: {
          itemSizes: true,
        },
      });

      return updatedClothes;
    } catch (error) {
      throw new Error("Error updating clothes: " + error.message);
    }
  }

  async deleteClothes(idItem) {
    try {
      await prisma.itemSizes.deleteMany({
        where: { idItem },
      });

      const deletedClothes = await prisma.clothes.delete({
        where: { idItem },
      });
      return deletedClothes;
    } catch (error) {
      throw new Error("Error deleting clothes: " + error.message);
    }
  }

  async getClothesById(idItem) {
    try {
      const clothes = await prisma.clothes.findUnique({
        where: { idItem },
        include: {
          itemSizes: true,
          store: true,
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching clothes by ID: " + error.message);
    }
  }

  async getClothesByStore(idStore) {
    try {
      const clothes = await prisma.clothes.findMany({
        where: {
          idStore,
        },
        include: {
          itemSizes: true,
          store: true,
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching clothes by store: " + error.message);
    }
  }

  async getAllClothes() {
    try {
      const clothes = await prisma.clothes.findMany({
        include: {
          itemSizes: true,
          store: true,
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching all clothes: " + error.message);
    }
  }

  async updateClothesQuantity(idItem, size, quantityChange) {
    try {
      const itemSize = await prisma.itemSizes.findUnique({
        where: { idItem_size: { idItem, size } },
      });

      if (!itemSize) {
        throw new Error(`Size ${size} for item ${idItem} not found`);
      }

      // Cập nhật số lượng
      const updatedQuantity = itemSize.quantity + quantityChange;
      if (updatedQuantity < 0) {
        throw new Error("Quantity cannot be less than zero");
      }

      await prisma.itemSizes.update({
        where: { idItem_size: { idItem, size } },
        data: { quantity: updatedQuantity },
      });

      return true;
    } catch (error) {
      console.error("Error updating clothes quantity:", error);
      throw new Error("Unable to update clothes quantity");
    }
  }
}

module.exports = new ClothesService();
