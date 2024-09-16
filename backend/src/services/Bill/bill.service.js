const prisma = require("../../config/prismaClient");

class BillService {
    async createBill(dataBill) {
        const bill = await prisma.bill.create({
        ...dataBill,
        });
        return bill;
    }
    
    async getBillById(id) {
        return await prisma.bill.findUnique({
        where: { idBill: id },
        });
    }
    
    async updateBill(idBill, dataBill) {
        return prisma.bill.update({
        where: { idBill: idBill },
        dataBill,
        });
    }
    
    async deleteBill(idBill) {
        return prisma.bill.delete({
        where: { idBill: idBill },
        });
    }
}

module.exports = BillService;