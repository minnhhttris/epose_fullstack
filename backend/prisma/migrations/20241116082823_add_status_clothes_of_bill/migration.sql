-- CreateEnum
CREATE TYPE "StatusType" AS ENUM ('CONFIRMED', 'RECEIVED', 'RETURNED', 'COMPLETED');

-- DropForeignKey
ALTER TABLE "Message" DROP CONSTRAINT "ReceiverStore_fkey";

-- DropForeignKey
ALTER TABLE "Message" DROP CONSTRAINT "SenderStore_fkey";

-- AlterTable
ALTER TABLE "Bill" ADD COLUMN     "lateFee" DOUBLE PRECISION NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "ClothesStatus" (
    "idStatus" TEXT NOT NULL,
    "idItem" TEXT NOT NULL,
    "idBill" TEXT NOT NULL,
    "statusType" "StatusType" NOT NULL,
    "description" TEXT NOT NULL,
    "images" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClothesStatus_pkey" PRIMARY KEY ("idStatus")
);

-- RenameForeignKey
ALTER TABLE "Message" RENAME CONSTRAINT "ReceiverUser_fkey" TO "Message_receiverId_fkey";

-- RenameForeignKey
ALTER TABLE "Message" RENAME CONSTRAINT "SenderUser_fkey" TO "Message_senderId_fkey";

-- AddForeignKey
ALTER TABLE "ClothesStatus" ADD CONSTRAINT "ClothesStatus_idItem_fkey" FOREIGN KEY ("idItem") REFERENCES "Clothes"("idItem") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClothesStatus" ADD CONSTRAINT "ClothesStatus_idBill_fkey" FOREIGN KEY ("idBill") REFERENCES "Bill"("idBill") ON DELETE RESTRICT ON UPDATE CASCADE;
