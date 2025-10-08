import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordle_flutter/app/app_colors.dart';
import 'package:wordle_flutter/wordle/data/word_list.dart';
import 'package:wordle_flutter/wordle/data/wordle_allowed_guesses.dart';
import 'package:wordle_flutter/wordle/models/letter_model.dart';
import 'package:wordle_flutter/wordle/models/word_model.dart';
import 'package:wordle_flutter/wordle/widgets/board.dart';
import 'package:wordle_flutter/wordle/widgets/keyboard.dart';

enum GameStatus { playing, submitting, won, lost }

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus _gameStatus = GameStatus.playing;

  final List<Word> _board = List.generate(
    6,
    (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
  );

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.fromString(
    wordleAllowedGuesses[Random().nextInt(wordleAllowedGuesses.length)]
        .toUpperCase(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Wordle',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board),
          const SizedBox(height: 80),
          Keyboard(
            onKeyTapped: _onKeyTapped, 
            onDeleteTapped: _onDeleteTapped, 
            onEnterTapped: _onEnterTapped),
          ]),
    );
  }

  void _onKeyTapped(String letter) {
    if (_gameStatus != GameStatus.playing) {
      setState(() => _currentWord?.addLetter(letter));
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus != GameStatus.playing) {
      setState(() => _currentWord?.removeLetter());
    }
  }

  void _onEnterTapped() {
    if (_gameStatus != GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
          _gameStatus = GameStatus.submitting;

          for (var i = 0; i < _currentWord!.letters.length; i++) {
            final currentWordLetter = _currentWord!.letters[i];
            final currentSolutionLetter = _solution.letters[i];

            setState(() {
              if (currentWordLetter == currentSolutionLetter) {
                _currentWord!.letters[i] = currentWordLetter.copyWith(status: LetterStatus.correct);
              } else if (_solution.letters.contains(currentWordLetter)) {
                _currentWord!.letters[i] = currentWordLetter.copyWith(status: LetterStatus.inWord);
              } else {
                _currentWord!.letters[i] = currentWordLetter.copyWith(status: LetterStatus.notInWord);
              }
            });
          }
          _checkIfWinOrLoss();
    }
  }

  void _checkIfWinOrLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: correctColor,
          content: const Text(
            'Congratulations! You won!',
            style: TextStyle(color: Colors.white),
            ),
            action: SnackBarAction(
              label: 'New Game',
              textColor: Colors.white,
              onPressed: _restartGame,
            ),
        ),
      );
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.redAccent[200],
          content: Text(
            'You lost! Solution: ${_solution.wordString}',
            style: TextStyle(color: Colors.white),
            ),
            action: SnackBarAction(
              label: 'New Game',
              textColor: Colors.white,
              onPressed: _restartGame,
            ),
        ),
      );
    } else {
      _gameStatus = GameStatus.playing;
    }
    _currentWordIndex++;
  }

  void _restartGame() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
          ),
        );
        _solution = Word.fromString(
          wordleAllowedGuesses[Random().nextInt(wordleAllowedGuesses.length)]
              .toUpperCase(),
        );
    });
  }
}
