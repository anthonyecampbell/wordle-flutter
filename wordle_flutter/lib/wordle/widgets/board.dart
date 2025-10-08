import 'package:flutter/material.dart';
import 'package:wordle_flutter/wordle/models/letter_model.dart';
import 'package:wordle_flutter/wordle/models/word_model.dart';
import 'package:wordle_flutter/wordle/widgets/board_tile.dart';
import 'package:flip_card/flip_card.dart';

class Board extends StatelessWidget {
  final List<Word> board;

  final List<List<GlobalKey<FlipCardState>>> flipCardKeys;

  const Board({
    Key? key, 
    required this.board,
    required this.flipCardKeys
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
        .asMap()
          .map(
            (boardIndex, word) => MapEntry(boardIndex, 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: word.letters
              .asMap()
                  .map((letterIndex, letter) => MapEntry(
                    letterIndex, 
                    FlipCard(
                      key: flipCardKeys[boardIndex][letterIndex],
                      flipOnTouch: false,
                      direction: FlipDirection.VERTICAL,
                      front: BoardTile(
                        letter: Letter(
                          value: letter.value, 
                          status: LetterStatus.initial,
                        ),
                      ),
                      back: BoardTile(letter: letter),
                    ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            ),
          )
          .values
          .toList(),
    );
  }
}
