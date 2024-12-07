const MessageService = require("../../services/Message/message.service");

class MessageController {
  async createMessage(req, res) {
    try {
      const message = await MessageService.createMessage(req.body);
      return res.status(201).json({
        success: true,
        data: message,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }

  async getMessagesForUser(req, res) {
    try {
      const messages = await MessageService.getMessagesForUser(
        req.params.userId
      );
      return res.status(200).json({
        success: true,
        data: messages,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }

  async getMessageById(req, res) {
    try {
      const message = await MessageService.getMessageById(req.params.messageId);
      if (message) {
        return res.status(200).json({
          success: true,
          data: message,
        });
      } else {
        return res.status(404).json({
          success: false,
          error: "Message not found",
        });
      }
    } catch (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }

  async updateMessage(req, res) {
    try {
      const updatedMessage = await MessageService.updateMessage(
        req.params.messageId,
        req.body
      );
      return res.status(200).json({
        success: true,
        data: updatedMessage,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }

  async deleteMessage(req, res) {
    try {
      await MessageService.deleteMessage(req.params.messageId);
      return res.status(204).json({
        success: true,
        message: "Message deleted successfully",
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }

  async getConversations(req, res) {
    try {
      const userId = req.user_id; 
      const conversations = await MessageService.getConversations(userId);
      return res.status(200).json({
        success: true,
        data: conversations,
      });
    } catch (error) {
      return res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }
}

module.exports = new MessageController();
