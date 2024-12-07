const storeService = require('../../services/Store/store.service');
const CLOUDINARY = require("../../config/cloudinaryConfig");

class StoreController {
  async createStore(req, res) {
    try {
      const idUser = req.user_id;
      const storeData = req.body;

      let logoUrl = null;
      if (req.file) {
        const fileUpload = await CLOUDINARY.uploader.upload(req.file.path);
        logoUrl = fileUpload.secure_url;
        storeData.logo = logoUrl;
      }

      const store = await storeService.createStore(idUser, storeData);
      return res.status(200).json({ success: true, data: store });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }

  async approveStore(req, res) {
    try {
      const storeData = req.body;
      const store = await storeService.approveStore(storeData);
      return res.status(200).json({ success: true, data: store });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }

  async approveEmployee(req, res) {
    try {
      const { storeId } = req.params;
      const { userId } = req.body;
      const employee = await storeService.approveEmployee(storeId, userId);
      return res.status(200).json(employee);
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }

  async updateStore(req, res) {
    try {
      const idStore = req.body.idStore;
      const storeData = req.body;

      console.log("req.file", req.file);

      let logoUrl = null;
      if (req.file) {
        const fileUpload = await CLOUDINARY.uploader.upload(req.file.path);
        logoUrl = fileUpload.secure_url;
        storeData.logo = logoUrl;
      }
      else if (storeData.logo && storeData.logo.startsWith("http")) {
        logoUrl = storeData.logo; 
      }

      console.log("storeData", storeData);

      if (!idStore) {
        return res.status(400).json({ error: "Store ID is required." });
      }

      const store = await storeService.updateStore(idStore, storeData);
      return res.status(200).json({ success: true, data: store });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }

  async deleteStore(req, res) {
    try {
      const { storeId } = req.params;
      await storeService.deleteStore(storeId);
      return res.status(204).send({ success: true});
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }

  async getStoreById(req, res) {
    try {
      const { idStore } = req.params;
      const store = await storeService.getStoreById(idStore);

      return res.status(200).json({ success: true ,data: store });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }

  async getStoreByIdUserLogin(req, res) {
    try {
      const idUser = req.user_id; 

      const store = await storeService.getStoreByIdUser(idUser);

      if (!store) {
        return res.status(404).json({ message: "Cửa hàng không tồn tại." });
      }

      return res.status(200).json({ success: true ,data: store }); 
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message }); 
    }
  }

  async getStoreByIdUser(req, res) {
    try {
      const { idUser } = req.params;
      const store = await storeService.getStoreByIdUser(idUser);

      if (!store) {
        return res.status(404).json({ message: "Cửa hàng không tồn tại." });
      }

      return res.status(200).json({ success: true, data: store });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }

  async getAllStores(req, res) {
    try {
      const stores = await storeService.getAllStores();
      return res.status(200).json({ success: true, stores });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  }
}

module.exports = new StoreController();
