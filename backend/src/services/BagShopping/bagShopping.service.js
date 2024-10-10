const prisma = require("../../config/prismaClient");

class BagShoppingService {
  async addToBagShopping(idUser, idStore, idItem, quantity) {
    // Kiểm tra xem người dùng có giỏ hàng chưa
    let bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser }, // Sử dụng findFirst để tìm giỏ hàng dựa trên idUser
    });

    // Nếu chưa có, tạo mới giỏ hàng
    if (!bagShopping) {
      bagShopping = await prisma.bagShopping.create({
        data: { idUser },
      });
    }

    // Kiểm tra sản phẩm đã có trong giỏ hàng chưa
    const existingItem = await prisma.bagItem.findUnique({
      where: {
        idBag_idItem: {
          idBag: bagShopping.idBag,
          idItem,
        },
      },
    });

    if (existingItem) {
      // Nếu sản phẩm đã có, cập nhật số lượng
      return await prisma.bagItem.update({
        where: { idBagItem: existingItem.idBagItem },
        data: { quantity: existingItem.quantity + quantity },
      });
    } else {
      // Nếu chưa có trong giỏ, tạo mới
      return await prisma.bagItem.create({
        data: {
          idBag: bagShopping.idBag,
          idStore,
          idItem,
          quantity,
        },
      });
    }
  }

  async updateBagItemQuantity(idUser, idItem, quantity) {
    const bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser },
    });

    if (!bagShopping) {
      throw new Error("Giỏ hàng không tồn tại");
    }

    return await prisma.bagItem.updateMany({
      where: {
        idBag: bagShopping.idBag,
        idItem,
      },
      data: { quantity },
    });
  }

  async removeFromBagShopping(idUser, idItem) {
    // Tìm giỏ hàng của người dùng
    const bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser }, 
    });

    if (!bagShopping) {
      throw new Error("Giỏ hàng không tồn tại");
    }

    // Xóa sản phẩm khỏi giỏ hàng
    return await prisma.bagItem.delete({
      where: {
        idBag_idItem: {
          idBag: bagShopping.idBag, 
          idItem, 
        },
      },
    });
  }

  async getUserBagShopping(idUser) {
    const bagShopping = await prisma.bagShopping.findFirst({
      where: { idUser },
      include: {
        items: {
          include: {
            clothes: true,
            store: true,
          },
        },
      },
    });

    return bagShopping;
  }
}

module.exports = new BagShoppingService();
