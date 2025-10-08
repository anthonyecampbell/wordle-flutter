import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wordle_flutter/app/app_colors.dart';

enum LetterStatus { initial, notInWord, inWord, correct }

class Letter extends Equatable {
  final String value;
  final LetterStatus status;

  const Letter({required this.value, this.status = LetterStatus.initial});

  factory Letter.empty() => const Letter(value: '');

  Color get backgroundColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.transparent;
      case LetterStatus.notInWord:
        return notInWordColor;
      case LetterStatus.inWord:
        return inWordColor;
      case LetterStatus.correct:
        return correctColor;
    }
  }

  Color get borderColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Letter copyWith({String? value, LetterStatus? status}) {
    return Letter(value: value ?? this.value, status: status ?? this.status);
  }

  @override
  List<Object?> get props => [value, status];
}
