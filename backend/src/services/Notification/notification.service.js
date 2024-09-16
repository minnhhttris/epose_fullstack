const prisma = require("../../config/prismaClient");

class NotificationService {
    async createNotification(dataNotification) {
        const notification = await prisma.notification.create({
        ...dataNotification,
        });
        return notification;
    }
    
    async getNotificationById(id) {
        return await prisma.notification.findUnique({
        where: { idNotification: id },
        });
    }
    
    async updateNotification(idNotification, dataNotification) {
        return prisma.notification.update({
        where: { idNotification: idNotification },
        dataNotification,
        });
    }
    
    async deleteNotification(idNotification) {
        return prisma.notification.delete({
        where: { idNotification: idNotification },
        });
    }
}
    
module.exports = NotificationService;