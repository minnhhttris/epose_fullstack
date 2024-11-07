import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/rating_controller.dart';


class RatingPage extends GetView<RatingController> {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá đơn thuê'),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ],
            ),
          ),
        ),
        );
      }
  }