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

    const store = prisma.store.create({
      data: {
        idUser: idUser,
        nameStore: storeData.nameStore,
        license: storeData.license,
        address: storeData.address,
        taxCode: storeData.taxCode,
        logo: logoUrl,
      },
    });
    return store;
  }

  async approveStore(storeData) {
    await prisma.storeUser.create({
      data: {
        idStore: storeData.idStore,
        idUser: storeData.idUser,
        role: "owner",
      },
    });

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
    await prisma.storeUser.deleteMany({ where: { idStore: idStore } });
    return prisma.store.delete({ where: { idStore: idStore } });
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
      throw new Error("User không sở hữu cửa hàng nào.");
    }

    const store = await prisma.store.findUnique({
      where: { idStore: storeUser.idStore },
      include: {
        user: true, 
      },
    });

    return store;
  }

  async getAllStores() {
    return prisma.store.findMany({
      include: { user: true, clothes: true },
    });
  }
}

module.exports = new StoreService();
