const billService = require("../../services/Bill/bill.service");

class BillController {
  // Tạo hóa đơn mới
  async createBill(req, res) {
    const idUser = req.user_id;
    const idStore = req.params.idStore;
    const dataBill = req.body;

    try {
      const newBill = await billService.createBill(idUser, idStore, dataBill);
      return res.status(201).json({
        success: true,
        message: "Bill has been created successfully!",
        data: newBill,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot create bill!",
        error: error.message,
      });
    }
  }

  // Lấy hóa đơn theo ID
  async getBillById(req, res) {
    const { id } = req.params;

    try {
      const bill = await billService.getBillById(id);
      if (!bill) {
        return res.status(404).json({
          success: false,
          message: "Bill not found!",
        });
      }
      return res.status(200).json({
        success: true,
        data: bill,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot get bill!",
        error: error.message,
      });
    }
  }

  //Lấy hóa đơn theo ID người dùng đang đăng nhập 
  async getBillByLoginUser(req, res) {
    const idUser = req.user_id;

    try {
      const bill = await billService.getBillByIdUser(idUser);
      if (!bill) {
        return res.status(404).json({
          success: false,
          message: "Bill not found!",
        });
      }
      return res.status(200).json({
        success: true,
        data: bill,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot get bill!",
        error: error.message,
      });
    }
  }

  //lấy hóa đơn theo ID người dùng
  async getBillByIdUser(req, res) {
    const idUser = req.params.idUser;

    try {
      const bill = await billService.getBillByIdUser(idUser);
      if (!bill) {
        return res.status(404).json({
          success: false,
          message: "Bill not found!",
        });
      }
      return res.status(200).json({
        success: true,
        data: bill,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot get bill!",
        error: error.message,
      });
    }
  }

  //Lấy hóa đơn theo ID cửa hàng
  async getBillByIdStore(req, res) {
    const idStore = req.params.idStore;

    try {
      const bill = await billService.getBillByIdStore(idStore);
      if (!bill) {
        return res.status(404).json({
          success: false,
          message: "Bill not found!",
        });
      }
      return res.status(200).json({
        success: true,
        data: bill,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot get bill!",
        error: error.message,
      });
    }
  }

  // Lấy danh sách hóa đơn
  async getAllBills(req, res) {
    try {
      const bills = await billService.getAllBills(req.query);
      return res.status(200).json({
        success: true,
        data: bills,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot get bills!",
        error: error.message,
      });
    }
  }

  // Cập nhật hóa đơn
  async updateBill(req, res) {
    const { id } = req.params;
    const dataBill = req.body;

    try {
      const updatedBill = await billService.updateBill(id, dataBill);
      return res.status(200).json({
        success: true,
        message: "Bill has been updated successfully!",
        data: updatedBill,
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot update bill!",
        error: error.message,
      });
    }
  }

  // Xóa hóa đơn
  async deleteBill(req, res) {
    const { id } = req.params;

    try {
      await billService.deleteBill(id);
      return res.status(200).json({
        success: true,
        message: "Bill has been deleted successfully!",
      });
    } catch (error) {
      return res.status(500).json({
        success: false,
        message: "Cannot delete bill!",
        error: error.message,
      });
    }
  }
}

module.exports = new BillController();
