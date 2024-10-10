const storeService = require('../../services/Store/store.service');

class StoreController {
  async createStore(req, res) {
    try {
      const idUser = req.user_id;
      const storeData = req.body;
      const store = await storeService.createStore(idUser, storeData);
      res.status(201).json(store);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async approveStore(req, res) {
    try {
      const storeData = req.body;
      const store = await storeService.approveStore(storeData);
      res.status(200).json(store);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async approveEmployee(req, res) {
    try {
      const { storeId } = req.params;
      const { userId } = req.body;
      const employee = await storeService.approveEmployee(storeId, userId);
      res.status(200).json(employee);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async updateStore(req, res) {
    try {
      const idStore = req.body.idStore;
      const storeData = req.body;

      if (!idStore) {
        return res.status(400).json({ error: "Store ID is required." });
      }

      const store = await storeService.updateStore(idStore, storeData);
      res.status(200).json(store);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async deleteStore(req, res) {
    try {
      const { storeId } = req.params;
      await storeService.deleteStore(storeId);
      res.status(204).send();
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getStoreByIdUser(req, res) {
    try {
      const idUser = req.user_id; 

      const store = await storeService.getStoreByIdUser(idUser);

      if (!store) {
        return res.status(404).json({ message: "Cửa hàng không tồn tại." });
      }

      res.status(200).json(store); 
    } catch (error) {
      res.status(500).json({ error: error.message }); 
    }
  }

  async getAllStores(req, res) {
    try {
      const stores = await storeService.getAllStores();
      res.status(200).json(stores);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new StoreController();
