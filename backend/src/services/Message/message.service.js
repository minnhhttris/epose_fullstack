const prisma = require("../../config/prismaClient");

class MessageService {
  async createMessage(dataMessage) {
    try {
      const message = await prisma.message.create({
        dataMessage: dataMessage,
      });
      return message;
    } catch (error) {
      throw new Error(`Failed to create message: ${error.message}`);
    }
  }

  async getMessagesForUser(userId) {
    try {
      // Fetch messages where user is either sender or receiver
      const messages = await prisma.message.findMany({
        where: {
          OR: [
            { senderId: userId },
            { receiverId: userId }
          ]
        }
      });
      return messages;
    } catch (error) {
      throw new Error(`Failed to fetch messages: ${error.message}`);
    }
  }

  async getMessageById(messageId) {
    try {
      const message = await prisma.message.findUnique({
        where: { idMessage: messageId }
      });
      return message;
    } catch (error) {
      throw new Error(`Failed to fetch message: ${error.message}`);
    }
  }

  async updateMessage(messageId, data) {
    try {
      const updatedMessage = await prisma.message.update({
        where: { idMessage: messageId },
        data,
      });
      return updatedMessage;
    } catch (error) {
      throw new Error(`Failed to update message: ${error.message}`);
    }
  }

  async deleteMessage(messageId) {
    try {
      await prisma.message.delete({
        where: { idMessage: messageId }
      });
    } catch (error) {
      throw new Error(`Failed to delete message: ${error.message}`);
    }
  }
}

module.exports = new MessageService();
