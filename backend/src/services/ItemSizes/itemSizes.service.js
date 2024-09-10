const prisma = require("../../config/prismaClient");

class ItemSizesService {
  async updateSizeQuantity(idItem, size, newQuantity) {
    const updatedItemSize = await prisma.itemSizes.update({
      where: {
        idItem_size: { idItem, size },
      },
      data: {
        quantity: newQuantity,
      },
    });

    const itemSizes = await prisma.itemSizes.findMany({ where: { idItem } });
    const totalQuantity = itemSizes.reduce(
      (acc, size) => acc + size.quantity,
      0
    );

    await prisma.clothes.update({
      where: { idItem },
      data: { number: totalQuantity },
    });

    return updatedItemSize;
  }

  async getItemSizes(idItem) {
    return prisma.itemSizes.findMany({
      where: { idItem },
    });
  }
}

module.exports = new ItemSizesService();
