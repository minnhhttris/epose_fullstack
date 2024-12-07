const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const cloudinary = require("./cloudinaryConfig");

// Cấu hình lưu trữ cho ảnh avatar trong epose_images/user_avatar
const avatarStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "epose_images/user_avatar",
    allowed_formats: ["jpg", "png", "jpeg", "gif", "webp"],
    public_id: (req, file) => `avatar_${Date.now()}_${file.originalname}`,
  },
});

// Cấu hình lưu trữ cho ảnh CCCD_img trong epose_images/user_cccd_images
const cccdStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "epose_images/user_cccd_images",
    allowed_formats: ["jpg", "png", "jpeg", "gif", "webp"],
    public_id: (req, file) => `cccd_${Date.now()}_${file.originalname}`,
  },
});

// Cấu hình lưu trữ cho ảnh logo store trong epose_images/store_logo
const logoStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "epose_images/store_logo",
    allowed_formats: ["jpg", "png", "jpeg", "gif", "webp"],
    public_id: (req, file) => `logo_${Date.now()}_${file.originalname}`,
  },
});

// Cấu hình lưu trữ cho listPicture của Clothes trong epose_images/clothes_images
const clothesStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "epose_images/clothes_images",
    allowed_formats: ["jpg", "png", "jpeg", "gif", "webp"],
    public_id: (req, file) => `clothes_${Date.now()}_${file.originalname}`,
  },
});

const clothesStatusStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "epose_images/clothesStatus_images",
    allowed_formats: ["jpg", "png", "jpeg", "gif", "webp"],
    public_id: (req, file) => `clothes_${Date.now()}_${file.originalname}`,
  },
});

// Cấu hình lưu trữ cho picture của Posts trong epose_images/posts_images
const postStorage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "epose_images/posts_images",
    allowed_formats: ["jpg", "png", "jpeg", "gif", "webp"],
    public_id: (req, file) => `post_${Date.now()}_${file.originalname}`,
  },
});

// Cấu hình Multer với bộ lọc file chung
const fileFilter = (req, file, cb) => {
  if (
    file.mimetype === "image/jpg" || 
    file.mimetype === "image/jpeg" ||
    file.mimetype === "image/png" ||
    file.mimetype === "image/gif" ||
    file.mimetype === "image/webp"
  ) {
    cb(null, true);
  } else {
    cb(new Error("Chỉ cho phép định dạng ảnh JPG, JPEG, PNG, GIF, WebP!"), false);
  }
};

// Middleware upload cho từng loại ảnh
const uploadAvatar = multer({ storage: avatarStorage, fileFilter }).single(
  "avatar"
);

const uploadCCCD = multer({ storage: cccdStorage, fileFilter }).array(
  "CCCD_img",
  2
);

const uploadLogo = multer({ storage: logoStorage, fileFilter }).single("logo");

const uploadClothesImages = multer({
  storage: clothesStorage,
  fileFilter,
}).array("listPicture", 10);

const uploadClothesStatusImages = multer({
  storage: clothesStatusStorage,
  fileFilter,
}).array("images", 10);

const uploadPostImages = multer({ storage: clothesStatusStorage, fileFilter }).array(
  "picture",
  10
);

module.exports = {
  uploadAvatar,
  uploadCCCD,
  uploadLogo,
  uploadClothesImages,
  uploadClothesStatusImages,
  uploadPostImages,
};
