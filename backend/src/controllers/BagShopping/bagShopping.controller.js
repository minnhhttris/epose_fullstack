const bagShoppingService = require("../../services/BagShopping/bagShopping.service");

class BagShoppingController {
  async addToBagShopping(req, res) {
    const idUser = req.user_id;
    const { idStore, idItem } = req.params;
    const { quantity } = req.body;

    try {
      const bagItem = await bagShoppingService.addToBagShopping(
        idUser,
        idStore,
        idItem,
        parseInt(quantity)
      );
      return res.status(200).json({
        success: true,
        message: "Sản phẩm đã được thêm vào giỏ hàng!",
        data: bagItem,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể thêm sản phẩm vào giỏ hàng!",
        error: error.message,
      });
    }
  }

  async updateQuantity(req, res) {
    const idUser = req.user_id;
    const { idItem } = req.params;
   const { quantity } = req.body;

    try {
      await bagShoppingService.updateBagItemQuantity(
        idUser,
        idItem,
        parseInt(quantity)
      );
      return res.status(200).json({
        success: true,
        message: "Số lượng sản phẩm trong giỏ hàng đã được cập nhật!",
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể cập nhật số lượng sản phẩm trong giỏ hàng!",
        error: error.message,
      });
    }
  }

  async removeFromBag(req, res) {
    const idUser = req.user_id;
    const { idItem } = req.params;

    try {
      await bagShoppingService.removeFromBagShopping(idUser, idItem);
      return res.status(200).json({
        success: true,
        message: "Sản phẩm đã được xóa khỏi giỏ hàng!",
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể xóa sản phẩm khỏi giỏ hàng!",
        error: error.message,
      });
    }
  }

  async getUserBag(req, res) {
    const idUser = req.user_id;

    try {
      const bagShopping = await bagShoppingService.getUserBagShopping(idUser);
      return res.status(200).json({
        success: true,
        data: bagShopping,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Không thể lấy giỏ hàng của người dùng!",
        error: error.message,
      });
    }
  }
}

module.exports = new BagShoppingController();
