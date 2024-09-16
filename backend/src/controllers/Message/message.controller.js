const UserService = require("../../services/Message/message.service");
const COOKIE_OPTIONS = require("../../config/cookieOptions");
const { message } = require("../../config/prismaClient");
// Create a new message
router.post("/messages", async (req, res) => {
  try {
    const message = await MessageService.createMessage(req.body);
    res.status(201).json(message);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Get all messages for a specific user
router.get("/messages/user/:userId", async (req, res) => {
  try {
    const messages = await MessageService.getMessagesForUser(req.params.userId);
    res.status(200).json(messages);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Get a single message by ID
router.get("/messages/:messageId", async (req, res) => {
  try {
    const message = await MessageService.getMessageById(req.params.messageId);
    if (message) {
      res.status(200).json(message);
    } else {
      res.status(404).json({ error: "Message not found" });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Update a message
router.put("/messages/:messageId", async (req, res) => {
  try {
    const updatedMessage = await MessageService.updateMessage(
      req.params.messageId,
      req.body
    );
    res.status(200).json(updatedMessage);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Delete a message
router.delete("/messages/:messageId", async (req, res) => {
  try {
    await MessageService.deleteMessage(req.params.messageId);
    res.status(204).send();
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
