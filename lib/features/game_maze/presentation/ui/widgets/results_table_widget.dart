import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/initial_bindings.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../stores/game_store.dart';
import 'row_words_widget.dart';

class ResultsTableWidget extends StatelessWidget {
  const ResultsTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DI.instance<GameStore>();

    return Observer(
      builder: (_) {
        final founds = store.categorizedFounds;
        final totalWords = store.currentGame?.listWordsFound.length ?? 0;
        final isWinned = store.isWinned;

        Color getMilestoneColor(int target) =>
            totalWords >= target ? AppColors.main : AppColors.darkBackground;

        return Table(
          children: [
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    "Palavras Encontradas",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    "Conquistas Diárias",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (founds["+"]!.isNotEmpty)
                      RowWordsWidget(
                        title: "+",
                        listWord: founds["+"]!,
                        win: isWinned,
                      ),
                    RowWordsWidget(
                      title: "Sete",
                      listWord: founds["7"]!,
                      win: isWinned,
                    ),
                    RowWordsWidget(
                      title: "Seis",
                      listWord: founds["6"]!,
                      win: isWinned,
                    ),
                    RowWordsWidget(
                      title: "Cinco",
                      listWord: founds["5"]!,
                      win: isWinned,
                    ),
                    RowWordsWidget(
                      title: "Quatro",
                      listWord: founds["4"]!,
                      win: isWinned,
                    ),
                    RowWordsWidget(
                      title: "Três",
                      listWord: founds["3"]!,
                      win: isWinned,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "25 palavras",
                      style: TextStyle(
                        fontSize: 12,
                        color: getMilestoneColor(25),
                      ),
                    ),
                    Text(
                      "50 palavras",
                      style: TextStyle(
                        fontSize: 12,
                        color: getMilestoneColor(50),
                      ),
                    ),
                    Text(
                      "75 palavras",
                      style: TextStyle(
                        fontSize: 12,
                        color: getMilestoneColor(75),
                      ),
                    ),
                    Text(
                      "+100 palavras",
                      style: TextStyle(
                        fontSize: 12,
                        color: getMilestoneColor(100),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
