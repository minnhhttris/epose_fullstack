/*
  Warnings:

  - Made the column `size` on table `BagItem` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "BagItem" ALTER COLUMN "size" SET NOT NULL,
ALTER COLUMN "size" DROP DEFAULT;
