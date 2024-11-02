const prisma = require("../../config/prismaClient");

class BagShoppingService {
  async addToBagShopping(idUser, idStore, idItem, quantity, size) {
    // Kiểm tra sản phẩm có tồn tại không
    const itemExists = await prisma.clothes.findUnique({
      where: { idItem },
    });

    if (!itemExists) {
      throw new Error("Sản phẩm không tồn tại trong hệ thống!");
    }

    let bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser },
    });

    if (!bagShopping) {
      bagShopping = await prisma.bagShopping.create({
        data: { idUser },
      });
    }

    const existingItem = await prisma.bagItem.findFirst({
      where: {
          idBag: bagShopping.idBag,
          idItem,
          size,
      },
    });

    if (existingItem) {
      return await prisma.bagItem.update({
        where: { idBagItem: existingItem.idBagItem },
        data: { quantity: existingItem.quantity + quantity },
      });
    } else {
      return await prisma.bagItem.create({
        data: {
          idBag: bagShopping.idBag,
          idStore,
          idItem,
          quantity,
          size,
        },
      });
    }
  }

  async updateBagItemQuantity(idUser, idItem, quantity, size) {
    const bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser },
    });

    if (!bagShopping) {
      throw new Error("Giỏ hàng không tồn tại");
    }

    const existingItem = await prisma.bagItem.findFirst({
      where: {
        idBag: bagShopping.idBag,
        idItem,
        size,
      },
    });

    if (!existingItem) {
      throw new Error("Sản phẩm không tồn tại trong giỏ hàng");
    }

    return await prisma.bagItem.update({
      where: { idBagItem: existingItem.idBagItem },
      data: { quantity },
    });
  }

  async removeFromBagShopping(idUser, idItem, size) {
    const bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser },
    });

    if (!bagShopping) {
      throw new Error("Giỏ hàng không tồn tại");
    }

    return await prisma.bagItem.deleteMany({
      where: {
        idBag: bagShopping.idBag,
        idItem,
        size,
      },
    });
  }

  async getUserBagShopping(idUser) {
    const bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser },
      include: {
        items: {
          include: {
            clothes: {
              include: {
                itemSizes: true,
              },
            },
            store: true,
          },
        },
      },
    });

    return bagShopping;
  }
}

module.exports = new BagShoppingService();
