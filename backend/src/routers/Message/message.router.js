const express = require("express");
const router = express.Router();
const MessageController = require("../../controllers/Message/message.controller");
const { verifyToken } = require("../../middlewares/verifyToken");

router.post("/", verifyToken, MessageController.createMessage);

router.get(
  "/user/:userId",
  verifyToken,
  MessageController.getMessagesForUser
);

router.get(
  "/:messageId",
  verifyToken,
  MessageController.getMessageById
);

router.put(
  "/:messageId",
  verifyToken,
  MessageController.updateMessage
);

router.delete(
  "/:messageId",
  verifyToken,
  MessageController.deleteMessage
);

router.get("/conversations/", verifyToken, MessageController.getConversations);

module.exports = router;
