import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/initial_bindings.dart';
import '../../stores/game_store.dart';
import 'rounded_card_widget.dart';

class GameGridWidget extends StatelessWidget {
  const GameGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DI.instance<GameStore>();

    return Observer(
      builder: (_) {
        final mazeStr = store.currentGame?.maze.maze ?? "";
        if (mazeStr.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          width: MediaQuery.of(context).size.height > 950 ? 700 : 475,
          child: GridView.count(
            crossAxisCount: 8,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(mazeStr.length, (index) {
              return RoundedCardWidget(
                width: MediaQuery.of(context).size.width,
                char: mazeStr[index],
                isClicked: store.gridClicked[index],
                isShowingFound:
                    (store.listClickSequence.contains(index) &&
                    store.isShowingFound),
                onClick: () {
                  if (!store.isShowingFound) {
                    store.addChar(char: mazeStr[index], index: index);
                  }
                },
              );
            }),
          ),
        );
      },
    );
  }
}
