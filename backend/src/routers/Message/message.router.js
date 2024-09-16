const express = require("express");
const router = express.Router();
const MessageController = require("../../controllers/Message/message.controller");
const { verifyToken } = require("../../middlewares/verifyToken");


router.post("/messages", verifyToken, MessageController.createMessage);
router.get(
  "/messages/user/:userId",
  verifyToken,
  MessageController.getMessagesForUser
);
router.get(
  "/messages/:messageId",
  verifyToken,
  MessageController.getMessageById
);
router.put(
  "/messages/:messageId",
  verifyToken,
  MessageController.updateMessage
);
router.delete(
  "/messages/:messageId",
  verifyToken,
  MessageController.deleteMessage
);

module.exports = router;
