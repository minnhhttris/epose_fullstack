const prisma = require('../../config/prismaClient');
const CLOUDINARY = require("../../config/cloudinaryConfig");

class StoreService {
  async createStore(idUser, storeData) {
    let logoUrl = null;

    if (storeData.logo) {
      if (storeData.logo.startsWith("http")) {
        logoUrl = storeData.logo;
      } else {
        const uploadResult = await CLOUDINARY.uploader.upload(
          storeData.logo.path
        );
        logoUrl = uploadResult.secure_url;
      }
    }

    const store = await prisma.store.create({
      data: {
        idUser: idUser,
        nameStore: storeData.nameStore,
        license: storeData.license,
        address: storeData.address,
        taxCode: storeData.taxCode,
        logo: logoUrl,
      },
    });

    await prisma.storeUser.create({
      data: {
        idStore: store.idStore,
        idUser: idUser,
        role: "owner",
      },
    });

    return store;
  }

  async approveStore(storeData) {
    // Chỉ cần cập nhật trạng thái cửa hàng và vai trò của người dùng
    const store = await prisma.store.update({
      where: {
        idStore: storeData.idStore,
      },
      data: {
        status: "active",
      },
    });

    await prisma.user.update({
      where: {
        idUser: storeData.idUser,
      },
      data: {
        role: "owner",
      },
    });

    return store;
  }

  async requestEmployee(storeId, userId) {
    return prisma.storeUser.create({
      data: {
        idStore: storeId,
        idUser: userId,
      },
    });
  }

  async approveEmployee(storeId, userId) {
    return prisma.storeUser.update({
      data: {
        idStore: storeId,
        idUser: userId,
        role: "employee",
      },
    });
  }

  async updateStore(idStore, storeData) {
    return await prisma.store.update({
      where: {
        idStore: idStore,
      },
      data: storeData,
    });
  }

  async deleteStore(idStore) {
    try {
      const updatedStore = await prisma.store.update({
        where: { idStore },
        data: {
          isActive: false,
        },
      });

      return updatedStore;
    } catch (error) {
      throw new Error("Error deleting store: " + error.message);
    }
  }

  async getStoreById(idStore) {
    return prisma.store.findUnique({
      where: { idStore },
      include: {
        user: true,
        clothes: {
          include: { itemSizes: true },
        },
        posts: {
          include: { comments: true },
        },
      },
    });
  }

  async getStoreByIdUser(idUser) {
    const storeUser = await prisma.storeUser.findFirst({
      where: {
        idUser: idUser,
      },
      select: {
        idStore: true,
      },
    });

    if (!storeUser) {
      console.log(`No store found for user ${idUser}`);
      throw new Error("User không sở hữu cửa hàng nào.");
    }

    const store = await prisma.store.findUnique({
      where: { idStore: storeUser.idStore, isActive: true },
      include: {
        user: true,
      },
    });

    return store;
  }

  async getAllStores() {
    return await prisma.store.findMany({
      where: {
        isActive: true,
      },
      include: {
        user: true,
        clothes: true,
        posts: true,
      },
    });
  }
}

module.exports = new StoreService();
