import 'package:flutter/material.dart';

const List<String> kSplashWords = [
  'Goal-setting',
  'Dedication',
  'Workflow',
  'Efficiency',
  'Concentration',
  'Discipline',
  'Balance',
  'Productivity',
  'Time-manager',
  'Performance',
  'Focus.',
];

class WordListView extends StatelessWidget {
  final Color textColor;
  final FontWeight fontWeight;
  final double progress;
  final double lineHeight;
  final double? activeStarCenterY;
  final double topOffset;

  const WordListView({
    super.key,
    required this.textColor,
    this.fontWeight = FontWeight.w500,
    this.progress = 1.0,
    this.lineHeight = 48.0,
    this.activeStarCenterY,
    this.topOffset = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(kSplashWords.length, (index) {
        final word = kSplashWords[index];

        double opacity = 1.0;

        // Active highlighted overlay: fully reveals the active word in stark solid black under clipper
        if (activeStarCenterY != null) {
          final wordCenterY = topOffset + (index + 0.5) * lineHeight;
          final distance = (wordCenterY - activeStarCenterY!).abs();
          final highlightRadius = lineHeight * 0.95;
          final highlight = (1.0 - (distance / highlightRadius)).clamp(
            0.0,
            1.0,
          );
          opacity = Curves.easeInOut.transform(highlight);
        }

        if (opacity <= 0.001) {
          return SizedBox(height: lineHeight);
        }

        return Opacity(
          opacity: opacity,
          child: SizedBox(
            height: lineHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                word,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: fontWeight,
                  color: textColor,
                  letterSpacing: -1.0,
                  height: 1.05,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
