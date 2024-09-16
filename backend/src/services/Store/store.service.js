const prisma = require('../../config/prismaClient');

class StoreService {
  async checkStoreExists(idUser) {
    return await prisma.store.findUnique({
      where: {
        idUser: idUser,
      },
    });
  }

  async createStore(idUser, nameStore, license, address, taxCode, logo, ) {
    const store = prisma.store.create({
      data: {
        idUser: idUser,
        nameStore: nameStore,
        license: license,
        address: address,
        taxCode: taxCode,
        logo: logo,
      },
    });
    return store;
  }

  async approveStore(idStore, userId) {
    await prisma.storeUser.create({
      data: {
        idStore: idStore,
        idUser: userId,
        role: "owner",
      },
    });

    await prisma.store.update({
      where: {
        idStore: idStore,
      },
      data: {
        status: "active",
      },
    });

    await prisma.user.update({
      where: {
        idUser: userId,
      },
      data: {
        role: "owner",
      },
    });
    return idStore;
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

  async updateStore(storeId, storeData) {
    return prisma.store.update({
      where: { idStore: storeId },
      data: {
        ...storeData,
      },
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
