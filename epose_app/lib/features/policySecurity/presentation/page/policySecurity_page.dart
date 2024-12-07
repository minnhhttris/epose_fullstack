import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../controller/policySecurity_controller.dart';

class PolicySecurityPage extends GetView<PolicySecurityController> {
  const PolicySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chính sách và bảo mật"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "I.Chính sách bảo mật",
              style: TextStyle(
                fontSize: AppDimens.textSize18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Tài khoản của khách hàng được bảo vệ bởi mật khẩu cá nhân, khách hàng có trách nhiệm bảo mật mật khẩu và không chia sẻ với bất kỳ ai.\n"
              "- Chúng tôi không bao giờ yêu cầu khách hàng cung cấp mật khẩu qua điện thoại, email hoặc bất kỳ phương thức nào khác.\n"
              "- Trong trường hợp nghi ngờ tài khoản bị xâm nhập, khách hàng cần thay đổi mật khẩu ngay lập tức và thông báo với chúng tôi để được hỗ trợ.\n"
              "- Tất cả các hoạt động trên tài khoản được ghi lại để đảm bảo an ninh và hỗ trợ xử lý khi có sự cố.\n"
              "- Thông tin tài khoản chỉ được sử dụng cho mục đích liên quan đến dịch vụ thuê quần áo và không chia sẻ với bất kỳ bên thứ ba nào nếu không có sự đồng ý từ khách hàng.",
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Chúng tôi sử dụng các biện pháp bảo mật tiên tiến như mã hóa dữ liệu, tường lửa và các công nghệ phòng chống xâm nhập để bảo vệ thông tin tài khoản của khách hàng.\n"
              "- Khách hàng chịu trách nhiệm đăng xuất tài khoản khỏi các thiết bị công cộng sau khi sử dụng để đảm bảo an toàn.",
            ),
            const SizedBox(height: AppDimens.spacing10),

            Text(
              "II.Chính sách thuê quần áo",
              style: TextStyle(
                fontSize: AppDimens.textSize18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            Text(
              "1. Điều kiện thuê:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Khách hàng cần cung cấp CCCD/hộ chiếu hợp lệ để xác thực danh tính.\n"
              "- Tài khoản thuê phải được đăng ký với thông tin chính xác, đầy đủ.\n"
              "- Quần áo chỉ được sử dụng cá nhân, không được cho thuê lại, bán hoặc sử dụng vào mục đích trái pháp luật.",
            ),
            const SizedBox(height: AppDimens.spacing10),
            Text(
              "2. Quy trình thuê quần áo:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Lựa chọn sản phẩm và kiểm tra tình trạng quần áo trên ứng dụng.\n"
              "- Xác nhận thời gian thuê, địa điểm giao nhận quần áo.\n"
              "- Thanh toán qua các hình thức được hỗ trợ: thẻ tín dụng, ví điện tử.\n"
              "- Nhận quần áo tại địa điểm đã đăng ký hoặc qua hình thức giao hàng.",
            ),
            const SizedBox(height: AppDimens.spacing10),
            Text(
              "3. Trách nhiệm của khách hàng:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Đảm bảo quần áo không bị hư hỏng, mất mát trong thời gian thuê.\n"
              "- Trả quần áo đúng thời hạn, tránh phát sinh phí phạt.\n"
              "- Thanh toán đầy đủ các khoản phí thuê, phí giao nhận, và phí bồi thường (nếu có).\n"
              "- Thông báo ngay cho dịch vụ khách hàng nếu có vấn đề với quần áo nhận được (rách, sai kích thước, không đúng mẫu mã).",
            ),
            const SizedBox(height: AppDimens.spacing10),
            Text(
              "4. Chính sách hoàn trả:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Quần áo phải được trả lại trong tình trạng sạch sẽ, nguyên vẹn.\n"
              "- Nếu quần áo bị hư hỏng nhẹ, khách hàng sẽ chịu chi phí sửa chữa theo quy định.\n"
              "- Trong trường hợp quần áo bị mất hoặc hư hỏng nặng không thể sửa chữa, khách hàng phải bồi thường toàn bộ giá trị sản phẩm.\n"
              "- Phí phạt sẽ được áp dụng nếu trả quần áo muộn hơn thời gian quy định.",
            ),
            const SizedBox(height: AppDimens.spacing10),
            Text(
              "5. Quy định hủy đơn thuê:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Khách hàng có thể hủy đơn trước thời gian giao quần áo tối thiểu 24 giờ mà không bị phạt.\n"
              "- Hủy đơn trong vòng 24 giờ trước khi giao hàng sẽ bị mất phí hủy là 50% giá trị thuê.\n"
              "- Nếu quần áo đã được giao, việc hủy đơn không được chấp nhận và khách hàng phải thanh toán toàn bộ chi phí thuê.",
            ),
            const SizedBox(height: AppDimens.spacing10),
            Text(
              "6. Chính sách bảo mật:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Mọi thông tin cá nhân khách hàng cung cấp sẽ được bảo mật tuyệt đối.\n"
              "- Thông tin chỉ được sử dụng cho mục đích quản lý thuê quần áo và hỗ trợ khách hàng.\n"
              "- Chúng tôi không chia sẻ thông tin khách hàng với bất kỳ bên thứ ba nào mà không có sự đồng ý từ khách hàng.\n"
              "- Ứng dụng áp dụng các biện pháp bảo mật tiên tiến để đảm bảo an toàn dữ liệu người dùng.",
            ),
            const SizedBox(height: AppDimens.spacing10),
            Text(
              "7. Chính sách đổi/trả quần áo:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Quần áo bị lỗi, sai mẫu mã hoặc kích thước không đúng sẽ được đổi miễn phí trong vòng 24 giờ kể từ khi nhận hàng.\n"
              "- Khách hàng cần giữ quần áo trong tình trạng nguyên vẹn và thông báo ngay khi phát hiện vấn đề.\n"
              "- Chúng tôi không hỗ trợ trả lại quần áo đã qua sử dụng, ngoại trừ trường hợp sản phẩm bị lỗi từ nhà cung cấp.",
            ),
            const SizedBox(height: AppDimens.spacing10),
            Text(
              "Liên hệ hỗ trợ:",
              style: TextStyle(
                fontSize: AppDimens.textSize16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spacing5),
            const Text(
              "- Email: ntmtri02@gmail.com\n"
              "- Số điện thoại: 1900-123-456\n"
              "- Địa chỉ: Tầng 10, Tòa nhà ABC, Quận 1, TP. Hồ Chí Minh.\n"
              "- Thời gian làm việc: 08:00 - 20:00 từ Thứ 2 đến Chủ Nhật.",
            ),
          ],
        ),
      ),
    );
  }
}
