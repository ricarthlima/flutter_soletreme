import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_colors.dart';

class BlinkingPointerWidget extends StatelessWidget {
  const BlinkingPointerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 18,
        child: Center(
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FadeAnimatedText(
                "|",
                textStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBackground,
                ),
                duration: const Duration(milliseconds: 1000),
                fadeInEnd: 0.1,
                fadeOutBegin: 0.9,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
