import 'package:flutter/material.dart';

class SkeletonChip extends StatelessWidget {
  const SkeletonChip({super.key, this.width = 72});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 32,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
