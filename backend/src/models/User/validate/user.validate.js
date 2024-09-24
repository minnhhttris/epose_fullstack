const Joi = require('joi');

class USER_VALIDATES {
    static registerValidate = Joi.object({

        email: Joi.string().email({
            minDomainSegments: 2,
            tlds: {
                allow: ['com', 'net', 'edu', 'vn']
            }
        }).required().messages({
            'string.email': 'Email phải là một địa chỉ email hợp lệ.',
            'string.empty': 'Email là bắt buộc.'
        }),

        password: Joi.string().min(6).max(32).pattern(
            new RegExp(
                "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*])(?!.*\\s).*$"
            )
        ).required().messages({
            'string.min': 'Mật khẩu phải chứa ít nhất 6 ký tự.',
            'string.max': 'Mật khẩu không được vượt quá 32 ký tự.',
            'string.pattern.base': 'Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt.',
            'string.empty': 'Mật khẩu là bắt buộc.'
        }),

        userName: Joi.string().trim()
            .min(5)
            .max(150)
            .custom((value, helpers) => {
                if (value.split(" ").length < 2) {
                    return helpers.message("Họ và tên phải chứa ít nhất hai từ.");
                }
                return value;
            })
            .messages({
                "string.base": "Họ và tên phải là một chuỗi ký tự.",
                "string.min": "Họ và tên phải có ít nhất 5 ký tự.",
                "string.max": "Họ và tên phải có nhiều nhất 150 ký tự.",
            }),

        phoneNumbers: Joi.string().pattern(/^[0-9]{10,15}$/).messages({
            'string.min': 'Số điện thoại phải chứa ít nhất 10 chữ số.'
        }),

        CCCD: Joi.string().min(12).max(12).message({
            'string.min': 'Số CCCD phải chứa đúng 12 ký tự.',
            'string.max': 'Số CCCD phải chứa đúng 12 ký tự.',
        }),

    })
}

module.exports = USER_VALIDATES;