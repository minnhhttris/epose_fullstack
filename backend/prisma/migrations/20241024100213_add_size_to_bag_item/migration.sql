/*
  Warnings:

  - A unique constraint covering the columns `[idBag,idItem,size]` on the table `BagItem` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `size` to the `BagItem` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "BagItem_idBag_idItem_key";

-- AlterTable
ALTER TABLE "BagItem" ADD COLUMN     "size" "SizeEnum" DEFAULT 'M';

-- CreateIndex
CREATE UNIQUE INDEX "BagItem_idBag_idItem_size_key" ON "BagItem"("idBag", "idItem", "size");
