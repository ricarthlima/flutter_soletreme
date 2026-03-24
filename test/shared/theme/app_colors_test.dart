import 'package:flutter/material.dart';
import 'package:flutter_soletreme/shared/theme/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('Deve manter as cores base do layout devem estar corretas', () {
      expect(AppColors.background, const Color(0xFF6B802F));
      expect(AppColors.darkBackground, const Color(0xFF29330E));
      expect(AppColors.border, const Color.fromARGB(136, 54, 64, 24));
      expect(AppColors.glow, const Color(0xFFC1E655));
    });
  });
}
