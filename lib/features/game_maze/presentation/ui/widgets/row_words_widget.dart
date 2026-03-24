import 'package:flutter/material.dart';
import '../../../../../shared/theme/app_colors.dart';

class RowWordsWidget extends StatelessWidget {
  final String title;
  final List<String> listWord;
  final bool win;

  const RowWordsWidget({
    super.key,
    required this.title,
    required this.listWord,
    required this.win,
  });

  @override
  Widget build(BuildContext context) {
    final String paddedTitle = title.padRight(8);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      width: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              paddedTitle,
              style: TextStyle(
                color: listWord.isEmpty ? Colors.white : AppColors.main,
                wordSpacing: -18,
                fontSize: 12,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: listWord.reversed.map((word) {
                  return Text(
                    "$word, ",
                    style: const TextStyle(
                      color: AppColors.darkBackground,
                      fontSize: 11,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
