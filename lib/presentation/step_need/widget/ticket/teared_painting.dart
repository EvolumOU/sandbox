import 'package:flutter/material.dart';

class TearedEffectPainter extends CustomPainter {
  final bool shift;
  final Color color;

  const TearedEffectPainter(this.color, {this.shift = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double width, double height) {
    Path path = Path();
    const n = 4;
    final x = width / n;
    final y = height / n;

    if (shift) {
      for (int i = 0; i < n; i++) {
        path
          ..lineTo((i + 1) * x - x / 2, y)
          ..lineTo((i + 1) * x, 0);
      }
    } else {
      path.moveTo(0, y);

      for (int i = 0; i < n; i++) {
        path
          ..lineTo(i * x + x / 2, 0)
          ..lineTo((i + 1) * x, y);
      }
    }

    path
      ..lineTo(n * x, n * y)
      ..lineTo(0, n * y)
      ..lineTo(0, y);

    return path;
  }

  @override
  bool shouldRepaint(TearedEffectPainter oldDelegate) => true;
}
