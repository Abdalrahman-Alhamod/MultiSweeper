import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/game_cubit/game_cubit.dart';
import 'package:minesweeper/helpers/app_font.dart';
import 'package:minesweeper/helpers/date_time_helper.dart';
import 'package:minesweeper/helpers/show_loading_dialog.dart';
import 'package:minesweeper/presentation/game_view.dart';

import '../helpers/show_custom_dialog.dart';

class LoadGameView extends StatelessWidget {
  const LoadGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listenWhen: (previous, current) {
        return previous != current &&
            (current is GameLoadFailure ||
                current is GameLoadSuccess ||
                current is GameDeleteLoading ||
                current is GameDeleteFailure ||
                current is GameDeleteSuccess);
      },
      buildWhen: (previous, current) {
        return previous != current && (current is GameDeleteSuccess);
      },
      listener: (context, state) async {
        if (state is GameLoadSuccess) {
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const GameView(),
            ),
            ModalRoute.withName('/'),
          );
        } else if (state is GameLoadFailure) {
          showCustomDialog(context, "Game Load",
              "Failed to load game!\nError : ${state.error}");
        } else if (state is GameDeleteLoading) {
          showLoadingDialog(context);
        } else if (state is GameDeleteSuccess) {
          Navigator.pop(context);
        } else if (state is GameDeleteFailure) {
          Navigator.pop(context);
          showCustomDialog(context, "Game Delete",
              "Failed to delete game!\nError : ${state.error}");
        }
      },
      builder: (context, state) {
        final saves = context.read<GameCubit>().getAllGameSaves();
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Game Saves",
              style: TextStyle(
                fontSize: 20,
                fontFamily: AppFonts.minesweeper,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.grey[300],
          ),
          backgroundColor: Colors.grey[300],
          body: ListView.builder(
            itemCount: saves.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  saves[index].name,
                  style: const TextStyle(fontSize: 24),
                ),
                subtitle: Text(
                  DateTimeHelper.format(
                    saves[index].date,
                    DateTimeFormat.dateAndTime,
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  context.read<GameCubit>().loadGame(id: saves[index].id);
                },
                trailing: IconButton(
                  onPressed: () {
                    context.read<GameCubit>().deleteGame(id: saves[index].id);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
