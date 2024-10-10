const prisma = require("../../config/prismaClient");
const CLOUDINARY = require("../../config/cloudinaryConfig");

class ClothesService {
  async createClothes(idStore, clothesData) {
    try {
      let uploadedImages = [];
      if (clothesData.listPicture && clothesData.listPicture.length > 0) {
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

  async updateClothes(idItem, updateData) {
    try {
      const existingClothes = await prisma.posts.findUnique({
        where: { idItem },
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

      const updatedClothes = await prisma.clothes.update({
        where: { idItem },
        data: {
          nameItem: updateData.nameItem || existingClothes.nameItem,
          description: updateData.description || existingClothes.description,
          price: updateData.price || existingClothes.price,
          listPicture: uploadedImages || existingClothes.listPicture,
          rate: updateData.rate || existingClothes.rate,
          favorite: updateData.favorite || existingClothes.favorite,
          color: updateData.color || existingClothes.color,
          style: updateData.style || existingClothes.style,
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
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching clothes by store: " + error.message);
    }
  }

  async searchClothes(searchQuery) {
    try {
      const whereConditions = [];

      // Tách chuỗi tìm kiếm thành các từ khóa
      const searchTerms = searchQuery
        .split(" ")
        .map((term) => term.trim())
        .filter((term) => term.length > 0);

      // Thêm các điều kiện tìm kiếm
      searchTerms.forEach((term) => {
        whereConditions.push({
          OR: [
            {
              nameItem: {
                contains: term,
                mode: "insensitive",
              },
            },
            {
              description: {
                contains: term,
                mode: "insensitive",
              },
            },
            {
              color: {
                contains: term,
                mode: "insensitive",
              },
            },
            {
              style: {
                contains: term,
                mode: "insensitive",
              },
            },
            {
              gender: {
                equals: term, // Tìm kiếm theo giới tính
              },
            },
          ],
        });
      });

      // Lấy tất cả quần áo thỏa mãn điều kiện
      const clothes = await prisma.clothes.findMany({
        where: {
          OR: whereConditions,
        },
        include: {
          itemSizes: true,
        },
      });

      // Sắp xếp kết quả dựa trên độ dài của chuỗi tìm kiếm (độ chính xác)
      const sortedClothes = clothes.sort((a, b) => {
        const scoreA = searchTerms.reduce((score, term) => {
          return (
            score +
            (a.nameItem.includes(term) ? 1 : 0) +
            (a.description.includes(term) ? 1 : 0)
          );
        }, 0);

        const scoreB = searchTerms.reduce((score, term) => {
          return (
            score +
            (b.nameItem.includes(term) ? 1 : 0) +
            (b.description.includes(term) ? 1 : 0)
          );
        }, 0);

        return scoreB - scoreA; // Sắp xếp theo độ chính xác (nhiều hơn lên trước)
      });

      return sortedClothes;
    } catch (error) {
      throw new Error("Error searching clothes: " + error.message);
    }
  }

  async getAllClothes() {
    try {
      const clothes = await prisma.clothes.findMany({
        include: {
          itemSizes: true,
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching all clothes: " + error.message);
    }
  }

  async getClothesByStyle(style) {
    try {
      const clothes = await prisma.clothes.findMany({
        where: {
          style,
        },
        include: {
          itemSizes: true,
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching clothes by style: " + error.message);
    }
  }

  async getClothesByColor(color) {
    try {
      const clothes = await prisma.clothes.findMany({
        where: {
          color: color,
        },
        include: {
          itemSizes: true,
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching clothes by color: " + error.message);
    }
  }

  async getClothesByGender(gender) {
    try {
      const clothes = await prisma.clothes.findMany({
        where: {
          gender: gender,
        },
        include: {
          itemSizes: true,
        },
      });
      return clothes;
    } catch (error) {
      throw new Error("Error fetching clothes by gender: " + error.message);
    }
  }

  async get10NewClothes() {
    try {
      console.log("Fetching new clothes");
      const clothes = await prisma.clothes.findMany({
        orderBy: {
          createdAt: "desc", 
        },
        take: 10, 
      });
      console.log(clothes);
      return clothes;
    } catch (error) {
      throw new Error("Error fetching new clothes: " + error.message);
    }
  }
}

module.exports = new ClothesService();
