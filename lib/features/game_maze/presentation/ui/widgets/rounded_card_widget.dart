import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_colors.dart';

class RoundedCardWidget extends StatelessWidget {
  final String char;
  final bool isClicked;
  final bool isShowingFound;
  final double width;
  final VoidCallback onClick;

  const RoundedCardWidget({
    super.key,
    required this.char,
    required this.onClick,
    required this.isClicked,
    required this.isShowingFound,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onClick(),
      onPanStart: (_) => onClick(),
      onTapCancel: onClick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 333),
        decoration: BoxDecoration(
          color: isShowingFound
              ? AppColors.main
              : isClicked
              ? AppColors.darkBackground
              : AppColors.background,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.border, width: 4),
        ),
        child: Center(
          child: Text(
            char.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width < 700 ? 24 : 36,
            ),
          ),
        ),
      ),
    );
  }
}
