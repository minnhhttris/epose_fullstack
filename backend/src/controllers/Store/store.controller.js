const storeService = require('../../services/Store/store.service');

class StoreController {
  async createStore(req, res) {
    try {
      const { userId } = req.user;
      const payload = req.body;
      const store = await storeService.createStore(
        idUser,
        nameStore,
        license,
        address,
        taxCode,
        logo
      );
      res.status(201).json(store);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async approveStore(req, res) {
    try {
      const { storeId } = req.params;
      const { userId } = req.user;
      const store = await storeService.approveStore(storeId, userId);
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
      const { storeId } = req.params;
      const storeData = req.body;
      const store = await storeService.updateStore(storeId, storeData);
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

  async getStoreById(req, res) {
    try {
      const { storeId } = req.params;
      const store = await storeService.getStoreById(storeId);
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
