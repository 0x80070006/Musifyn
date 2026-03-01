import 'dart:math';
import 'package:flutter/material.dart';

class BubbleData {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double wobbleOffset;
  double wobbleSpeed;
  double wobbleAmount;
  double driftX;

  BubbleData({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.wobbleOffset,
    required this.wobbleSpeed,
    required this.wobbleAmount,
    required this.driftX,
  });
}

class AnimatedBubbleBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBubbleBackground({super.key, required this.child});

  @override
  State<AnimatedBubbleBackground> createState() =>
      _AnimatedBubbleBackgroundState();
}

class _AnimatedBubbleBackgroundState extends State<AnimatedBubbleBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<BubbleData> _bubbles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _generateBubbles();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateBubbles)..repeat();
  }

  void _generateBubbles() {
    for (int i = 0; i < 18; i++) {
      _bubbles.add(_newBubble(startAnywhere: true));
    }
  }

  BubbleData _newBubble({bool startAnywhere = false}) {
    return BubbleData(
      x: _rng.nextDouble(),
      y: startAnywhere ? _rng.nextDouble() : 1.1 + _rng.nextDouble() * 0.3,
      size: 20.0 + _rng.nextDouble() * 80.0,
      speed: 0.00008 + _rng.nextDouble() * 0.00015,
      opacity: 0.08 + _rng.nextDouble() * 0.18,
      wobbleOffset: _rng.nextDouble() * pi * 2,
      wobbleSpeed: 0.3 + _rng.nextDouble() * 0.7,
      wobbleAmount: 0.015 + _rng.nextDouble() * 0.035,
      driftX: (_rng.nextDouble() - 0.5) * 0.00008,
    );
  }

  double _time = 0;

  void _updateBubbles() {
    _time += 0.016;
    setState(() {
      for (int i = 0; i < _bubbles.length; i++) {
        final b = _bubbles[i];
        b.y -= b.speed;
        b.x += sin(_time * b.wobbleSpeed + b.wobbleOffset) * b.wobbleAmount * 0.02;
        b.x += b.driftX;
        if (b.y < -0.15) {
          _bubbles[i] = _newBubble();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark gradient base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A1A0F),
                Color(0xFF050D0A),
                Color(0xFF020508),
              ],
            ),
          ),
        ),
        // Bubbles
        CustomPaint(
          painter: _BubblePainter(_bubbles),
        ),
        // Child
        widget.child,
      ],
    );
  }
}

class _BubblePainter extends CustomPainter {
  final List<BubbleData> bubbles;
  _BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bubbles) {
      final cx = b.x * size.width;
      final cy = b.y * size.height;
      final r = b.size / 2;

      // Outer glow
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF1DB954).withOpacity(b.opacity * 0.3),
            const Color(0xFF0D7FBF).withOpacity(b.opacity * 0.15),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 2.5));
      canvas.drawCircle(Offset(cx, cy), r * 2.5, glowPaint);

      // Bubble body
      final bodyPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.4),
          colors: [
            const Color(0xFF1DB954).withOpacity(b.opacity * 0.6),
            const Color(0xFF148A3C).withOpacity(b.opacity * 0.3),
            const Color(0xFF0D7FBF).withOpacity(b.opacity * 0.4),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
      canvas.drawCircle(Offset(cx, cy), r, bodyPaint);

      // Rim / border
      final rimPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = const Color(0xFF1DB954).withOpacity(b.opacity * 0.5);
      canvas.drawCircle(Offset(cx, cy), r, rimPaint);

      // Highlight
      final hlPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.5, -0.6),
          radius: 0.4,
          colors: [
            Colors.white.withOpacity(b.opacity * 0.6),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
      canvas.drawCircle(Offset(cx, cy), r * 0.5, hlPaint);
    }
  }

  @override
  bool shouldRepaint(_BubblePainter old) => true;
}
