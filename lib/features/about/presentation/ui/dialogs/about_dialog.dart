import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_colors.dart';
import '../about_screen.dart';

void showAboutSoletreMeDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: const Color.fromARGB(150, 0, 0, 0),
    builder: (context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkBackground,
            border: Border.all(width: 2, color: AppColors.glow),
            borderRadius: BorderRadius.circular(18),
          ),
          width: min(600, MediaQuery.of(context).size.width * 0.9),
          constraints: BoxConstraints(
            maxHeight: min(800, MediaQuery.of(context).size.height * 0.85),
          ),
          child: Stack(
            children: [
              // O conteúdo com scroll
              const SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: AboutContent(),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.glow),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
