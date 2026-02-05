import 'dart:math';
import 'package:flutter/material.dart';

class GradientGauge extends StatefulWidget {
  final double score;
  final double maxScore;
  final double size;

  const GradientGauge({
    Key? key,
    required this.score,
    this.maxScore = 900,
    this.size = 200,
  }) : super(key: key);

  @override
  _GradientGaugeState createState() => _GradientGaugeState();
}

class _GradientGaugeState extends State<GradientGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    final double targetRatio = widget.score / widget.maxScore;
    _animation = Tween<double>(begin: 0, end: targetRatio).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _GaugePainter(
              ratio: 1.0,
              color: Colors.grey.withOpacity(0.2),
              gradient: null,
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return RepaintBoundary(
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _GaugePainter(
                    ratio: _animation.value,
                    color: null,
                    gradient: const SweepGradient(
                      colors: [Colors.orange, Colors.green],
                      stops: [0.0, 1.0],
                      transform: GradientRotation(-pi / 2),
                    ),
                  ),
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('↑ 7',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
              Text(
                '${widget.score.toInt()}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
           Positioned(
            left: 20,
            bottom: widget.size * 0.08,
            child: const Text('300', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
           Positioned(
            right: 20,
            bottom: widget.size * 0.08,
            child: const Text('900', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double ratio;
  final Color? color;
  final Gradient? gradient;

  _GaugePainter({required this.ratio, this.color, this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 15.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (color != null) {
      paint.color = color!;
    }
    if (gradient != null) {
      paint.shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    }

    const double start = 2.61799;
    const double sweep = 4.18879;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      start,
      sweep * ratio,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.ratio != ratio;
  }
}
