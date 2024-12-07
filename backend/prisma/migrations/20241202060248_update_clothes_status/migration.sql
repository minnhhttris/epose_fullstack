/*
  Warnings:

  - Added the required column `idBillItem` to the `ClothesStatus` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "ClothesStatus" DROP CONSTRAINT "ClothesStatus_idItem_fkey";

-- AlterTable
ALTER TABLE "ClothesStatus" ADD COLUMN     "idBillItem" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "ClothesStatus" ADD CONSTRAINT "ClothesStatus_idBill_idItem_fkey" FOREIGN KEY ("idBill", "idItem") REFERENCES "BillItem"("idBill", "idItem") ON DELETE RESTRICT ON UPDATE CASCADE;
