import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class SmartMarquee extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double height;

  const SmartMarquee({
    super.key,
    required this.text,
    required this.style,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(text: text, style: style),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();

          final textWidth = textPainter.size.width;

          if (textWidth <= constraints.maxWidth) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(text, style: style, overflow: TextOverflow.ellipsis),
            );
          }

          return Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 80.0,
            velocity: 40.0,
            startAfter: Duration(seconds: 2),
            pauseAfterRound: Duration(seconds: 2),
            accelerationDuration: Duration(seconds: 1),
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
            startPadding: 16.0,
          );
        },
      ),
    );
  }
}
