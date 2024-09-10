const ItemSizesService = require("../../services/ItemSizes/itemSizes.service");

class ItemSizesController {
  async updateSizeQuantity(req, res) {
    const { idItem } = req.params;
    const { size, newQuantity } = req.body;

    try {
      const updatedItemSize = await ItemSizesService.updateSizeQuantity(
        idItem,
        size,
        newQuantity
      );
      res.status(200).json(updatedItemSize);
    } catch (error) {
      res.status(500).json({ error: "Failed to update item size quantity." });
    }
  }

  async getItemSizes(req, res) {
    const { idItem } = req.params;

    try {
      const sizes = await ItemSizesService.getItemSizes(idItem);
      res.status(200).json(sizes);
    } catch (error) {
      res.status(500).json({ error: "Failed to retrieve item sizes." });
    }
  }
}

module.exports = new ItemSizesController();
