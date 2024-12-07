import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/sales_controller.dart';

class SalesPage extends GetView<SalesController> {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doanh thu cửa hàng"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doanh thu thẻ
              Column(
                children: [
                  revenueCard(
                    "Tổng doanh thu",
                    controller.totalRevenue.value,
                    Colors.blueAccent,
                  ),
                  revenueCard(
                    "Doanh thu năm nay",
                    controller.yearlyRevenue.value,
                    Colors.green,
                  ),
                  revenueCard(
                    "Doanh thu tháng này",
                    controller.monthlyRevenue.value,
                    Colors.deepOrange,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Biểu đồ doanh thu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: "Biểu đồ doanh thu",
                    fontWeight: FontWeight.w500,
                  ),
                  Obx(() {
                    return ToggleButtons(
                      isSelected: [
                        controller.displayByMonth.value,
                        !controller.displayByMonth.value
                      ],
                      onPressed: (index) {
                        controller.displayByMonth.value = index == 0;
                      },
                      borderRadius: BorderRadius.circular(5),
                      selectedColor: Colors.white,
                      fillColor: Colors.blueAccent,
                      color: Colors.grey,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Tháng"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Năm"),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1.7,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: controller.totalRevenue.value != 0 
                      ? controller.totalRevenue.value
                      : 1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: controller.generateLineChartData(),
                        isCurved: false,
                        barWidth: 1.5,
                        color: Colors.blueAccent,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (FlSpot spot, double xPercentage,
                              LineChartBarData bar, int index) {
                            return FlDotCirclePainter(
                              radius: 0.6,
                              color: Colors.blueAccent,
                              strokeWidth: 1,
                              strokeColor: Colors.blueAccent,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: controller.totalRevenue.value > 5
                              ? controller.totalRevenue.value / 5
                              : 1,
                          getTitlesWidget: (value, meta) {
                            final formatter = NumberFormat.compactCurrency(
                              locale: 'vi_VN',
                              symbol: '',
                              decimalDigits: 0,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                formatter.format(value),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: controller.displayByMonth.value ? 5 : 1,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                controller.displayByMonth.value
                                    ? "${(value + 1).toInt()}"
                                    : "T${(value + 1).toInt()}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: controller.totalRevenue.value > 5
                          ? controller.totalRevenue.value / 5
                          : 1,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.5),
                        strokeWidth: 0.5,
                        dashArray: [4, 4],
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Colors.black, width: 1),
                        left: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget revenueCard(String title, double revenue, Color color) {
    final formattedRevenue =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(revenue);

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: color,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              text: title,
              size: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            Text(
              formattedRevenue,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
