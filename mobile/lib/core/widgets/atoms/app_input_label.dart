import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:flutter/material.dart';

class AppInputLabel extends StatelessWidget {
  const AppInputLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.ink,
    ),
  );
}
