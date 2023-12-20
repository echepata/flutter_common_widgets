import 'package:flutter/material.dart';

class BottomSheetPill extends StatelessWidget {
  const BottomSheetPill({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: 70,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isLight ? Colors.grey.shade300 : Colors.grey.shade700,
      ),
    );
  }
}
