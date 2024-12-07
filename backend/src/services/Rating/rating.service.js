const prisma = require("../../config/prismaClient");

class RatingService {
  // Thêm đánh giá
  async addRating(idUser, idBill, ratingData) {
    const { idItem, ratingstar, ratingcomment } = ratingData;

    // Lấy hóa đơn và kiểm tra trạng thái
    const bill = await prisma.bill.findUnique({
      where: { idBill },
      include: {
        billItems: true,
      },
    });

    if (!bill) {
      throw new Error("Hóa đơn không tồn tại.");
    }

    if (bill.idUser !== idUser || bill.statement !== "COMPLETED") {
      throw new Error(
        "Bạn chỉ có thể đánh giá sản phẩm trong hóa đơn đã hoàn thành."
      );
    }

    // Kiểm tra sản phẩm có thuộc hóa đơn không
    const billItem = bill.billItems.find((item) => item.idItem === idItem);
    if (!billItem) {
      throw new Error("Sản phẩm không thuộc hóa đơn này.");
    }

    // Thêm đánh giá
    await prisma.rating.create({
      data: {
        idUser,
        idItem,
        ratingstar,
        ratingcomment,
      },
    });

    await this.updateClothesRating(idItem);
    await this.updateStoreRating(bill.idStore);

    const ratedItems = await prisma.rating.findMany({
      where: {
        idItem: {
          in: bill.billItems.map((item) => item.idItem),
        },
      },
    });

    if (ratedItems.length === bill.billItems.length) {
      // Nếu tất cả sản phẩm đã được đánh giá, chuyển trạng thái hóa đơn sang RATING
      await prisma.bill.update({
        where: { idBill },
        data: {
          statement: "RATING",
        },
      });
    }

    return await prisma.bill.findUnique({
      where: { idBill },
      include: {
        billItems: {
          include: {
            clothes: {
              include: {
                itemSizes: true,
                rating: true,
              },
            },
          },
        },
        user: true,
        store: true,
      },
    });
  }

  // Cập nhật đánh giá
  async updateRating(idRating, idUser, updateData) {
    const { ratingstar, ratingcomment } = updateData;

    // Kiểm tra quyền sở hữu
    const rating = await prisma.rating.findUnique({
      where: { idRating },
    });

    if (!rating || rating.idUser !== idUser) {
      throw new Error("Bạn không có quyền chỉnh sửa đánh giá này.");
    }

    // Cập nhật đánh giá
    const updatedRating = await prisma.rating.update({
      where: { idRating },
      data: { ratingstar, ratingcomment },
    });

    // Cập nhật rate cho Clothes và Store
    await this.updateClothesRating(rating.idItem);

    const clothes = await prisma.clothes.findUnique({
      where: { idItem: rating.idItem },
    });
    await this.updateStoreRating(clothes.idStore);

    return updatedRating;
  }

  // Xóa đánh giá
  async deleteRating(idRating, idUser) {
    // Kiểm tra quyền sở hữu
    const rating = await prisma.rating.findUnique({
      where: { idRating },
    });

    if (!rating || rating.idUser !== idUser) {
      throw new Error("Bạn không có quyền xóa đánh giá này.");
    }

    const updatedRating = await prisma.rating.update({
      where: { idRating },
      data: {
        isActive: false,
      },
    });

    // Cập nhật rate cho Clothes và Store
    await this.updateClothesRating(rating.idItem);

    const clothes = await prisma.clothes.findUnique({
      where: { idItem: rating.idItem },
    });
    await this.updateStoreRating(clothes.idStore);

    return updatedRating;
  }

  // Cập nhật rate cho Clothes
  async updateClothesRating(idItem) {
    const ratings = await prisma.rating.findMany({
      where: { idItem },
    });

    const averageRating =
      ratings.reduce((sum, rating) => sum + rating.ratingstar, 0) /
      (ratings.length || 1);

    await prisma.clothes.update({
      where: { idItem },
      data: { rate: averageRating },
    });
  }

  // Cập nhật rate cho Store
  async updateStoreRating(idStore) {
    const clothes = await prisma.clothes.findMany({
      where: { idStore },
    });

    const totalRatings = await prisma.rating.findMany({
      where: {
        idItem: {
          in: clothes.map((clothe) => clothe.idItem),
        },
      },
    });

    const averageRating =
      totalRatings.reduce((sum, rating) => sum + rating.ratingstar, 0) /
      (totalRatings.length || 1);

    await prisma.store.update({
      where: { idStore },
      data: { rate: averageRating },
    });
  }

  // Lấy đánh giá theo IdItem
  async getRatingsByItem(idItem) {
    return await prisma.rating.findMany({
      where: {
        idItem: idItem,
        isActive: true,
      },
      include: { user: true },
      orderBy: {
        createdAt: "desc",
      },
    });
  }

  // Lấy đánh giá theo idBill
  async getRatingsByBill(idBill) {
    const bill = await prisma.bill.findUnique({
      where: { idBill },
    });

    if (!bill) {
      throw new Error("Hóa đơn không tồn tại.");
    }

    return await prisma.rating.findMany({
      where: {
        idItem: {
          in: bill.billItems.map((item) => item.idItem),
        },
        isActive: true, 
      },
      include: { user: true },
    });
  }
}

module.exports = new RatingService();
