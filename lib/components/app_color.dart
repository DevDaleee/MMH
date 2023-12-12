import 'package:flutter/material.dart';

class CharacteristicsIndicator extends StatelessWidget {
  final String label;
  final String userGuess;
  final String correctAnswer;

  const CharacteristicsIndicator({
    super.key,
    required this.label,
    required this.userGuess,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    bool isCorrect = userGuess.toLowerCase() == correctAnswer.toLowerCase();
    Color color = isCorrect ? Colors.green : Colors.red;

    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          "$label: ${isCorrect ? 'Correto' : correctAnswer}",
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
