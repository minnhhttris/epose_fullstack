/*
  Warnings:

  - Added the required column `quantity` to the `BillItem` table without a default value. This is not possible if the table is not empty.
  - Added the required column `size` to the `BillItem` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "BillItem" ADD COLUMN     "quantity" INTEGER NOT NULL,
ADD COLUMN     "size" "SizeEnum" NOT NULL;
