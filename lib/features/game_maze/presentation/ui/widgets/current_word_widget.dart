import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/initial_bindings.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../stores/game_store.dart';
import 'blinking_pointer_widget.dart';

class CurrentWordWidget extends StatelessWidget {
  const CurrentWordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DI.instance<GameStore>();

    return Observer(
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              store.currentWord,
              style: const TextStyle(
                fontSize: 32,
                color: AppColors.darkBackground,
              ),
            ),
            const BlinkingPointerWidget(),
          ],
        );
      },
    );
  }
}
