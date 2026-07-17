import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:flutter/material.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.alt_route_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      const SizedBox(width: 9),
      const Text(
        'Ayni Ruta',
        style: TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
