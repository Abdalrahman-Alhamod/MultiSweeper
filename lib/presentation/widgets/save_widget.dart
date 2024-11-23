import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/helpers/app_font.dart';
import 'package:minesweeper/helpers/show_custom_dialog.dart';
import 'package:minesweeper/helpers/show_loading_dialog.dart';

import '../../business_logic/game_cubit/game_cubit.dart';

class SaveWidget extends StatelessWidget {
  const SaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) {
        return previous != current &&
            (current is GameSaveLoading ||
                current is GameSaveFailure ||
                current is GameSaveSuccess);
      },
      listener: (context, state) {
        if (state is GameSaveLoading) {
          showLoadingDialog(context);
        } else if (state is GameSaveSuccess) {
          Navigator.pop(context);
          showCustomDialog(context, "Game Save", "Game saved successfully!");
        } else if (state is GameSaveFailure) {
          Navigator.pop(context);
          showCustomDialog(context, "Game Save",
              "Failed to save game\nError : ${state.error}");
        }
      },
      child: IconButton(
        onPressed: () {
          context.read<GameCubit>().saveGame();
        },
        icon: const Row(
          children: [
            Icon(
              Icons.save,
              size: 40,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Save Game",
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.minesweeper,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
