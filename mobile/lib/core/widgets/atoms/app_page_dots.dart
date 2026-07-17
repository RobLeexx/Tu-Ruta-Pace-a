import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:flutter/material.dart';

class AppPageDots extends StatelessWidget {
  const AppPageDots({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      count,
      (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: index == current ? 22 : 7,
        height: 7,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: index == current ? AppColors.ink : AppColors.hairline,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    ),
  );
}
