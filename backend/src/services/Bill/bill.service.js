const prisma = require("../../config/prismaClient");

class BillService {
  // Tạo hóa đơn mới
  async createBill(idUser, idStore, dataBill) {
    const { sum, downpayment, dateStart, dateEnd, items } = dataBill;

    return await prisma.bill.create({
      data: {
        idUser,
        idStore,
        sum,
        downpayment,
        dateStart: new Date(dateStart),
        dateEnd: new Date(dateEnd),
        statement: "UNPAID",
        billItems: {
          create: items.map((item) => ({
            idItem: item.idItem,
          })),
        },
      },
      include: {
        billItems: true,
      },
    });
  }

  // Lấy hóa đơn theo ID
  async getBillById(idBill) {
    return await prisma.bill.findUnique({
      where: { idBill },
      include: {
        billItems: {
          include: {
            clothes: true,
          },
        },
        user: true,
        store: true,
      },
    });
  }

  // Lấy hóa đơn theo ID người dùng
  async getBillByIdUser(idUser) {
    return await prisma.bill.findMany({
      where: { idUser },
      include: {
        billItems: true,
        user: true,
        store: true,
      },
    });
  }

  //Lấy hóa đơn theo ID cửa hàng
  async getBillByIdStore(idStore) {
    return await prisma.bill.findMany({
      where: { idStore },
      include: {
        billItems: true,
        user: true,
        store: true,
      },
    });
  }

  // Lấy danh sách hóa đơn
  async getAllBills(params) {
    const { skip = 0, take = 10, filter } = params;
    return await prisma.bill.findMany({
      where: filter,
      skip: parseInt(skip),
      take: parseInt(take),
      include: {
        billItems: true,
        user: true,
        store: true,
      },
      orderBy: {
        createdAt: "desc",
      },
    });
  }

  // Cập nhật hóa đơn
  async updateBill(idBill, dataBill) {
    return await prisma.bill.update({
      where: { idBill },
      data: {
        ...dataBill,
        updatedAt: new Date(),
      },
      include: {
        billItems: true,
      },
    });
  }

  // Xóa hóa đơn
  async deleteBill(idBill) {
    return await prisma.bill.delete({
      where: { idBill },
    });
  }
}

module.exports = new BillService();
