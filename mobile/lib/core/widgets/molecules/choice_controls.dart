import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    super.key,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: title,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF0F3) : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.hairline,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.strong,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: selected ? Colors.white : AppColors.ink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.primary : AppColors.muted,
            ),
          ],
        ),
      ),
    ),
  );
}

class ChoiceChips<T> extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.value,
    required this.values,
    required this.label,
    required this.onChanged,
  });

  final T value;
  final List<T> values;
  final String Function(T) label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: values.map((item) {
      final selected = item == value;
      return ChoiceChip(
        label: Text(label(item)),
        selected: selected,
        onSelected: (_) => onChanged(item),
        selectedColor: const Color(0xFFFFE6EB),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.hairline,
        ),
        labelStyle: TextStyle(
          color: selected ? AppColors.ink : AppColors.body,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      );
    }).toList(),
  );
}
