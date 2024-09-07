const prisma = require("../../config/prismaClient");

class ClothesService {
  async createClothes(idStore, clothesData) {
    const totalQuantity = clothesData.sizes.reduce(
      (sum, size) => sum + size.quantity,
      0
    );
    const newClothes = await prisma.clothes.create({
      data: {
        ...clothesData,
        idStore,
        number: totalQuantity,
        itemSizes: {
          createMany: {
            data: clothesData.sizes.map((size) => ({
              size: size.size,
              quantity: size.quantity,
            })),
          },
        },
        include: {
          itemSizes: true,
        },
      },
    });
    return newClothes;
  }

  async updateClothes(idItem, data) {
    const { nameItem, description, price, listPicture, tag } = data;

    const clothes = await prisma.clothes.update({
      where: { idItem },
      data: {
        nameItem,
        description,
        price,
        listPicture,
        tag,
      },
    });

    return clothes;
  }

  async getClothesByStore(idStore) {
    return await prisma.clothes.findMany({
      where: { idStore },
      include: { itemSizes: true },
    });
  }

  async getClothesById(idItem) {
    return await prisma.clothes.findUnique({
      where: { idItem },
      include: { itemSizes: true },
    });
  }

  async getAllClothes() {
    return await prisma.clothes.findMany({
      include: { itemSizes: true },
    });
  }

  async deleteClothes(idItem) {
    await prisma.storeUser.deleteMany({ where: { idItem: idItem } });
    return await prisma.clothes.delete({
      where: { idItem },
    });
  }
}

module.exports = new ClothesService();
