import 'package:equatable/equatable.dart';
import 'package:wordle_flutter/wordle/models/letter_model.dart';

class Word extends Equatable {
  final List<Letter> letters;

  const Word({required this.letters});

  factory Word.fromString(String word) =>
      Word(letters: word.split('').map((char) => Letter(value: char)).toList());

  String get wordString => letters.map((letter) => letter.value).join();

  void addLetter(String value) {
    final currentIndex = letters.indexWhere((letter) => letter.value.isEmpty);
    if (currentIndex != -1) {
      letters[currentIndex] = Letter(value: value);
    }
  }

  void removeLetter() {
    final currentIndex = letters.lastIndexWhere(
      (letter) => letter.value.isNotEmpty,
    );
    if (currentIndex != -1) {
      letters[currentIndex] = Letter.empty();
    }
  }

  @override
  List<Object?> get props => [letters];
}
