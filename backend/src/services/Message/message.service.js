const prisma = require("../../config/prismaClient");

class MessageService {
  async createMessage(dataMessage) {
    try {
      const message = await prisma.message.create({
        data: dataMessage,
      });
      return message;
    } catch (error) {
      throw new Error(`Failed to create message: ${error.message}`);
    }
  }

  async getMessagesForUser(userId) {
    try {
      const messages = await prisma.message.findMany({
        where: {
          OR: [{ senderId: userId }, { receiverId: userId }],
        },
        orderBy: { sendAt: "asc" },
      });
      return messages;
    } catch (error) {
      throw new Error(`Failed to fetch messages: ${error.message}`);
    }
  }

  async getMessageById(messageId) {
    try {
      const message = await prisma.message.findUnique({
        where: { idMessage: messageId },
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
        where: { idMessage: messageId },
      });
    } catch (error) {
      throw new Error(`Failed to delete message: ${error.message}`);
    }
  }

  async getConversations(userId) {
    try {
      // Lấy danh sách các cuộc hội thoại
      const conversations = await prisma.message.groupBy({
        by: ["senderId", "receiverId"],
        where: {
          OR: [{ senderId: userId }, { receiverId: userId }],
        },
        _max: {
          sendAt: true, // Lấy tin nhắn cuối cùng theo thời gian
        },
        orderBy: {
          _max: {
            sendAt: "desc",
          },
        },
      });

      // Lấy thông tin người dùng cho mỗi cuộc hội thoại
      const detailedConversations = await Promise.all(
        conversations.map(async (conv) => {
          const otherUserId =
            conv.senderId === userId ? conv.receiverId : conv.senderId;
          const otherUser = await prisma.user.findUnique({
            where: { idUser: otherUserId },
            select: {
              idUser: true,
              userName: true,
              email: true,
              avatar: true,
            },
          });

          return {
            otherUser,
            lastMessageTime: conv._max.sendAt,
          };
        })
      );

      return detailedConversations;
    } catch (error) {
      throw new Error(`Failed to fetch conversations: ${error.message}`);
    }
  }
}

module.exports = new MessageService();
