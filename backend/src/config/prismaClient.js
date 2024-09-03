// this file is config Prisma Client

const {
    PrismaClient
} = require('@prisma/client');
const prisma = new PrismaClient();

module.exports = prisma;