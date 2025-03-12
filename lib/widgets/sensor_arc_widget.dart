import 'package:flutter/material.dart';
import 'dart:math';

class SensorArc extends StatelessWidget {
  final double value;
  final double maxValue;
  final String label;
  final Color arcColor;

  SensorArc({
    required this.value,
    required this.maxValue,
    required this.label,
    this.arcColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(80, 80), // Arc boyutu
      painter: _SensorArcPainter(
        value: value,
        maxValue: maxValue,
        label: label,
        arcColor: arcColor,
      ),
    );
  }
}

class _SensorArcPainter extends CustomPainter {
  final double value;
  final double maxValue;
  final String label;
  final Color arcColor;

  _SensorArcPainter({
    required this.value,
    required this.maxValue,
    required this.label,
    required this.arcColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8;
    final double radius = size.width / 2 - strokeWidth / 2;

    // Arka plan çemberi
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, backgroundPaint);

    // Arc çizimi
    final Paint arcPaint = Paint()
      ..color = arcColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = 360 * (value / maxValue);
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    canvas.drawArc(
      rect,
      -90 * (pi / 180), // Başlangıç açısı (12 yönü)
      sweepAngle * (pi / 180), // Yay uzunluğu
      false,
      arcPaint,
    );

    // Sensör değerini ve etiketi gösterme
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${value.toStringAsFixed(1)}\n$label',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}