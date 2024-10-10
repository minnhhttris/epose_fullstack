-- CreateEnum
CREATE TYPE "Role" AS ENUM ('owner', 'employee', 'user', 'admin');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('active', 'inactive');

-- CreateEnum
CREATE TYPE "Statement" AS ENUM ('PAID', 'CONFIRMED', 'PENDING_PICKUP', 'DELIVERING', 'DELIVERED', 'CANCELLED', 'RETURNED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('male', 'female', 'unisex', 'other');

-- CreateEnum
CREATE TYPE "Style" AS ENUM ('ao_dai', 'tu_than', 'co_phuc', 'ao_ba_ba', 'da_hoi', 'nang_tho', 'hoc_duong', 'vintage', 'ca_tinh', 'sexy', 'cong_so', 'dan_toc', 'do_doi', 'hoa_trang', 'cac_nuoc');

-- CreateEnum
CREATE TYPE "Color" AS ENUM ('red', 'blue', 'green', 'yellow', 'black', 'white', 'pink', 'purple', 'orange', 'brown', 'gray', 'beige', 'colorfull');

-- CreateEnum
CREATE TYPE "SizeEnum" AS ENUM ('S', 'M', 'L', 'XL');

-- CreateTable
CREATE TABLE "User" (
    "idUser" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "userName" TEXT,
    "phoneNumbers" TEXT,
    "avatar" TEXT,
    "address" TEXT,
    "CCCD" TEXT,
    "CCCD_img" TEXT[],
    "gender" "Gender",
    "dateOfBirth" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "coins" INTEGER NOT NULL DEFAULT 0,
    "role" "Role" NOT NULL DEFAULT 'user',
    "isActive" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "User_pkey" PRIMARY KEY ("idUser")
);

-- CreateTable
CREATE TABLE "OTP" (
    "idOTP" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "otpType" TEXT NOT NULL,
    "expTime" TIMESTAMP(3) NOT NULL,
    "check_used" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "idUser" TEXT,

    CONSTRAINT "OTP_pkey" PRIMARY KEY ("idOTP")
);

-- CreateTable
CREATE TABLE "Store" (
    "idStore" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "nameStore" TEXT NOT NULL,
    "license" TEXT NOT NULL,
    "taxCode" TEXT NOT NULL,
    "logo" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "rate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "status" "Status" NOT NULL DEFAULT 'inactive',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Store_pkey" PRIMARY KEY ("idStore")
);

-- CreateTable
CREATE TABLE "Clothes" (
    "idItem" TEXT NOT NULL,
    "nameItem" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "listPicture" TEXT[],
    "rate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "favorite" INTEGER NOT NULL DEFAULT 0,
    "color" "Color" NOT NULL,
    "style" "Style" NOT NULL,
    "gender" "Gender" NOT NULL,
    "number" INTEGER NOT NULL DEFAULT 0,
    "idStore" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Clothes_pkey" PRIMARY KEY ("idItem")
);

-- CreateTable
CREATE TABLE "ItemSizes" (
    "idItemSize" TEXT NOT NULL,
    "idItem" TEXT NOT NULL,
    "size" "SizeEnum" NOT NULL,
    "quantity" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ItemSizes_pkey" PRIMARY KEY ("idItemSize")
);

-- CreateTable
CREATE TABLE "Rating" (
    "idRating" TEXT NOT NULL,
    "idItem" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "ratingstar" DOUBLE PRECISION NOT NULL,
    "ratingcomment" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Rating_pkey" PRIMARY KEY ("idRating")
);

-- CreateTable
CREATE TABLE "Bill" (
    "idBill" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "idStore" TEXT NOT NULL,
    "sum" DOUBLE PRECISION NOT NULL,
    "downpayment" DOUBLE PRECISION NOT NULL,
    "dateStart" TIMESTAMP(3) NOT NULL,
    "dateEnd" TIMESTAMP(3) NOT NULL,
    "statement" "Statement" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Bill_pkey" PRIMARY KEY ("idBill")
);

-- CreateTable
CREATE TABLE "BillItem" (
    "idBill" TEXT NOT NULL,
    "idItem" TEXT NOT NULL,

    CONSTRAINT "BillItem_pkey" PRIMARY KEY ("idBill","idItem")
);

-- CreateTable
CREATE TABLE "Posts" (
    "idPosts" TEXT NOT NULL,
    "caption" TEXT,
    "picture" TEXT[],
    "favorite" INTEGER NOT NULL DEFAULT 0,
    "idUser" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "idStore" TEXT NOT NULL,

    CONSTRAINT "Posts_pkey" PRIMARY KEY ("idPosts")
);

-- CreateTable
CREATE TABLE "Comment" (
    "idComment" TEXT NOT NULL,
    "idPosts" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "comment" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("idComment")
);

-- CreateTable
CREATE TABLE "Notification" (
    "idNotification" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "idStore" TEXT NOT NULL,
    "notification" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("idNotification")
);

-- CreateTable
CREATE TABLE "UserVoucher" (
    "idUserVoucher" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "idVoucher" TEXT NOT NULL,
    "redeemedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserVoucher_pkey" PRIMARY KEY ("idUserVoucher")
);

-- CreateTable
CREATE TABLE "Voucher" (
    "idVoucher" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "validFrom" TIMESTAMP(3) NOT NULL,
    "validTo" TIMESTAMP(3) NOT NULL,
    "dailyCheckIn" BOOLEAN NOT NULL DEFAULT false,
    "requiredCoins" INTEGER NOT NULL,

    CONSTRAINT "Voucher_pkey" PRIMARY KEY ("idVoucher")
);

-- CreateTable
CREATE TABLE "Message" (
    "idMessage" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "senderType" TEXT NOT NULL,
    "receiverType" TEXT NOT NULL,
    "senderId" TEXT NOT NULL,
    "receiverId" TEXT NOT NULL,
    "sendAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("idMessage")
);

-- CreateTable
CREATE TABLE "BagShopping" (
    "idBag" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BagShopping_pkey" PRIMARY KEY ("idBag")
);

-- CreateTable
CREATE TABLE "BagItem" (
    "idBagItem" TEXT NOT NULL,
    "idBag" TEXT NOT NULL,
    "idItem" TEXT NOT NULL,
    "idStore" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "BagItem_pkey" PRIMARY KEY ("idBagItem")
);

-- CreateTable
CREATE TABLE "Favorite" (
    "idFavorite" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "idPosts" TEXT NOT NULL,

    CONSTRAINT "Favorite_pkey" PRIMARY KEY ("idFavorite")
);

-- CreateTable
CREATE TABLE "StoreUser" (
    "idStore" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'user',

    CONSTRAINT "StoreUser_pkey" PRIMARY KEY ("idStore","idUser")
);

-- CreateTable
CREATE TABLE "Attendance" (
    "idAttendance" TEXT NOT NULL,
    "idUser" TEXT NOT NULL,
    "checkInTime" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attendance_pkey" PRIMARY KEY ("idAttendance")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_CCCD_key" ON "User"("CCCD");

-- CreateIndex
CREATE UNIQUE INDEX "Store_license_key" ON "Store"("license");

-- CreateIndex
CREATE UNIQUE INDEX "Store_taxCode_key" ON "Store"("taxCode");

-- CreateIndex
CREATE UNIQUE INDEX "ItemSizes_idItem_size_key" ON "ItemSizes"("idItem", "size");

-- CreateIndex
CREATE INDEX "Message_senderId_senderType_idx" ON "Message"("senderId", "senderType");

-- CreateIndex
CREATE INDEX "Message_receiverId_receiverType_idx" ON "Message"("receiverId", "receiverType");

-- CreateIndex
CREATE UNIQUE INDEX "BagItem_idBag_idItem_key" ON "BagItem"("idBag", "idItem");

-- CreateIndex
CREATE UNIQUE INDEX "Favorite_idUser_idPosts_key" ON "Favorite"("idUser", "idPosts");

-- CreateIndex
CREATE UNIQUE INDEX "Attendance_idUser_checkInTime_key" ON "Attendance"("idUser", "checkInTime");

-- AddForeignKey
ALTER TABLE "OTP" ADD CONSTRAINT "OTP_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Clothes" ADD CONSTRAINT "Clothes_idStore_fkey" FOREIGN KEY ("idStore") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemSizes" ADD CONSTRAINT "ItemSizes_idItem_fkey" FOREIGN KEY ("idItem") REFERENCES "Clothes"("idItem") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rating" ADD CONSTRAINT "Rating_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rating" ADD CONSTRAINT "Rating_idItem_fkey" FOREIGN KEY ("idItem") REFERENCES "Clothes"("idItem") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bill" ADD CONSTRAINT "Bill_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bill" ADD CONSTRAINT "Bill_idStore_fkey" FOREIGN KEY ("idStore") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillItem" ADD CONSTRAINT "BillItem_idBill_fkey" FOREIGN KEY ("idBill") REFERENCES "Bill"("idBill") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillItem" ADD CONSTRAINT "BillItem_idItem_fkey" FOREIGN KEY ("idItem") REFERENCES "Clothes"("idItem") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Posts" ADD CONSTRAINT "Posts_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Posts" ADD CONSTRAINT "Posts_idStore_fkey" FOREIGN KEY ("idStore") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_idPosts_fkey" FOREIGN KEY ("idPosts") REFERENCES "Posts"("idPosts") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_idStore_fkey" FOREIGN KEY ("idStore") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserVoucher" ADD CONSTRAINT "UserVoucher_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserVoucher" ADD CONSTRAINT "UserVoucher_idVoucher_fkey" FOREIGN KEY ("idVoucher") REFERENCES "Voucher"("idVoucher") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "SenderUser_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "SenderStore_fkey" FOREIGN KEY ("senderId") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "ReceiverUser_fkey" FOREIGN KEY ("receiverId") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "ReceiverStore_fkey" FOREIGN KEY ("receiverId") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BagShopping" ADD CONSTRAINT "BagShopping_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BagItem" ADD CONSTRAINT "BagItem_idBag_fkey" FOREIGN KEY ("idBag") REFERENCES "BagShopping"("idBag") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BagItem" ADD CONSTRAINT "BagItem_idItem_fkey" FOREIGN KEY ("idItem") REFERENCES "Clothes"("idItem") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BagItem" ADD CONSTRAINT "BagItem_idStore_fkey" FOREIGN KEY ("idStore") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_idPosts_fkey" FOREIGN KEY ("idPosts") REFERENCES "Posts"("idPosts") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoreUser" ADD CONSTRAINT "StoreUser_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoreUser" ADD CONSTRAINT "StoreUser_idStore_fkey" FOREIGN KEY ("idStore") REFERENCES "Store"("idStore") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attendance" ADD CONSTRAINT "Attendance_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("idUser") ON DELETE RESTRICT ON UPDATE CASCADE;
