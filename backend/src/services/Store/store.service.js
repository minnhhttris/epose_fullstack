const prisma = require('../../config/prismaClient');

class StoreService {
  
  async createStoreRequest(userId, storeData) {
    return prisma.store.create({
      data: {
        idUser: userId,
        ...storeData,
      },
    });
  }

  async approveStore(storeId, userId) {
    const store = await prisma.store.update({
      where: { idStore: storeId },
      data: { approved: true },
    });

    return prisma.storeUser.create({
      data: {
        idStore: storeId,
        idUser: userId,
        role: "owner",
      },
    });
  }


  async approveEmployee(storeId, userId) {
    return prisma.storeUser.create({
      data: {
        idStore: storeId,
        idUser: userId,
        role: "employee",
      },
    });
  }

  async updateStore(storeId, storeData) {
    return prisma.store.update({
      where: { idStore: storeId },
      data: storeData,
    });
  }

  async deleteStore(storeId) {
    await prisma.storeUser.deleteMany({ where: { idStore: storeId } });
    return prisma.store.delete({ where: { idStore: storeId } });
  }

  async getStoreById(storeId) {
    return prisma.store.findUnique({
      where: { idStore: storeId },
      include: { user: true, clothes: true },
    });
  }

  async getAllStores() {
    return prisma.store.findMany({
      include: { user: true, clothes: true },
    });
  }
}

module.exports = new StoreService();
