import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mmh/src/models/entities.dart';

class CharacteristicsIndicator extends StatelessWidget {
  final Entities userGuess;
  final Entities correctAnswer;

  const CharacteristicsIndicator({
    super.key,
    required this.userGuess,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildCharacteristicsWidgets(),
    );
  }

  List<Widget> _buildCharacteristicsWidgets() {
    List<Widget> widgets = [];
    Set<String> processedCharacteristics = {};

    var userGuessJson = userGuess.toJson();

    for (var key in userGuessJson.keys) {
      if (key == "name") {
        continue;
      }

      var value = userGuessJson[key];
      var characteristicString = "$key: $value";
      if (processedCharacteristics.contains(characteristicString)) {
        continue;
      }

      widgets.add(
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getIndicatorColor(key),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              characteristicString,
              style: TextStyle(color: _getIndicatorColor(key), fontSize: 15),
            ),
            if (key == "health") ...[
              const SizedBox(width: 5),
              _buildHealthIcon(value),
            ],
          ],
        ),
      );

      processedCharacteristics.add(characteristicString);
    }
    return widgets;
  }

  Widget _buildHealthIcon(dynamic healthValue) {
    if (healthValue == null) {
      return SizedBox.shrink();
    }

    int threshold = correctAnswer.getProperty("health") ?? 25;
    final IconData iconData;
    Color iconColor;

    if (healthValue > threshold) {
      iconData = FontAwesomeIcons.anglesDown;
      iconColor = Colors.red;
    } else if (healthValue < threshold) {
      iconData = FontAwesomeIcons.anglesUp;
      iconColor = Colors.red;
    } else {
      iconData = FontAwesomeIcons.equals;
      iconColor = Colors.green;
    }

    return Icon(iconData, color: iconColor, size: 14);
  }

  Color _getIndicatorColor(String property) {
    bool isCorrect = _compareValues(
      userGuess.getProperty(property),
      correctAnswer.getProperty(property),
    );

    return isCorrect ? Colors.green : Colors.red;
  }

  bool _compareValues(dynamic userValue, dynamic correctValue) {
    return userValue == correctValue;
  }
}
