import 'package:flutter/material.dart';
import 'package:quizcreator/theme/theme.dart';
import 'package:quizcreator/utils/constant/colors.dart';

class BuildLegendItem extends StatelessWidget {
  const BuildLegendItem({super.key, required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: ColorsApp.primaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
