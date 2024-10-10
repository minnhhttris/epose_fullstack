const multer = require("multer");
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const cloudinary = require("./cloudinaryConfig"); 

// Cấu hình lưu trữ Multer để upload ảnh lên Cloudinary
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "epose_images", 
    allowed_formats: ["jpg", "png"], 
  },
});

const upload = multer({ storage: storage });

module.exports = upload;
