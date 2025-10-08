import 'package:flutter/material.dart';
import 'package:wordle_flutter/wordle/models/word_model.dart';
import 'package:wordle_flutter/wordle/widgets/board_tile.dart';

class Board extends StatelessWidget {
  final List<Word> board;

  const Board({Key? key, required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
          .map(
            (word) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: word.letters
                  .map((letter) => BoardTile(letter: letter))
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
