import 'package:flutter/material.dart';

class FrogLogo extends StatelessWidget {
  final double size;
  const FrogLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FrogLogoPainter()),
    );
  }
}

class _FrogLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final greenPaint = Paint()..color = const Color(0xFF1DB954);
    final darkGreenPaint = Paint()..color = const Color(0xFF148A3C);
    final whitePaint = Paint()..color = Colors.white;
    final blackPaint = Paint()..color = const Color(0xFF0A0A0A);
    final bluePaint = Paint()..color = const Color(0xFF1ED760);

    // Body
    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.6), width: w * 0.7, height: h * 0.55));
    canvas.drawPath(bodyPath, greenPaint);

    // Head
    final headPath = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.35), width: w * 0.6, height: h * 0.38));
    canvas.drawPath(headPath, greenPaint);

    // Eyes background (protruding)
    canvas.drawCircle(Offset(w * 0.3, h * 0.18), w * 0.12, darkGreenPaint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.18), w * 0.12, darkGreenPaint);

    // Eyes white
    canvas.drawCircle(Offset(w * 0.3, h * 0.17), w * 0.085, whitePaint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.17), w * 0.085, whitePaint);

    // Pupils
    canvas.drawCircle(Offset(w * 0.31, h * 0.18), w * 0.045, blackPaint);
    canvas.drawCircle(Offset(w * 0.71, h * 0.18), w * 0.045, blackPaint);

    // Eye shine
    canvas.drawCircle(Offset(w * 0.285, h * 0.155), w * 0.015, whitePaint);
    canvas.drawCircle(Offset(w * 0.685, h * 0.155), w * 0.015, whitePaint);

    // Smile
    final smilePaint = Paint()
      ..color = darkGreenPaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(w * 0.36, h * 0.46)
      ..quadraticBezierTo(w * 0.5, h * 0.55, w * 0.64, h * 0.46);
    canvas.drawPath(smilePath, smilePaint);

    // Legs (back)
    final legPaint = Paint()..color = darkGreenPaint.color;
    // Left leg
    final leftLeg = Path()
      ..moveTo(w * 0.2, h * 0.75)
      ..quadraticBezierTo(w * 0.05, h * 0.82, w * 0.08, h * 0.95)
      ..quadraticBezierTo(w * 0.18, h * 0.98, w * 0.3, h * 0.88)
      ..quadraticBezierTo(w * 0.28, h * 0.78, w * 0.2, h * 0.75);
    canvas.drawPath(leftLeg, greenPaint);

    // Right leg
    final rightLeg = Path()
      ..moveTo(w * 0.8, h * 0.75)
      ..quadraticBezierTo(w * 0.95, h * 0.82, w * 0.92, h * 0.95)
      ..quadraticBezierTo(w * 0.82, h * 0.98, w * 0.7, h * 0.88)
      ..quadraticBezierTo(w * 0.72, h * 0.78, w * 0.8, h * 0.75);
    canvas.drawPath(rightLeg, greenPaint);

    // Music note on body
    final notePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // Note stem
    canvas.drawRect(
      Rect.fromLTWH(w * 0.52, h * 0.52, w * 0.06, h * 0.22),
      notePaint,
    );

    // Note head
    canvas.save();
    canvas.translate(w * 0.46, h * 0.72);
    canvas.rotate(-0.3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.16, height: w * 0.12),
      notePaint,
    );
    canvas.restore();

    // Flag
    final flagPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;
    final flagPath = Path()
      ..moveTo(w * 0.58, h * 0.52)
      ..quadraticBezierTo(w * 0.7, h * 0.56, w * 0.62, h * 0.63);
    canvas.drawPath(flagPath, flagPaint);

    // Blue accent circle
    final accentPaint = Paint()
      ..color = const Color(0xFF1ED760).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.47, accentPaint);
  }

  @override
  bool shouldRepaint(_FrogLogoPainter old) => false;
}
