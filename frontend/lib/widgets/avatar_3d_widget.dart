import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';

enum AvatarProblemArea {
  none,
  heart,
  head,
  lungs,
}

class Avatar3DWidget extends StatefulWidget {
  final AvatarProblemArea problemArea;
  final bool hasIssue;

  const Avatar3DWidget({
    super.key,
    this.problemArea = AvatarProblemArea.none,
    this.hasIssue = false,
  });

  @override
  State<Avatar3DWidget> createState() => _Avatar3DWidgetState();
}

class _Avatar3DWidgetState extends State<Avatar3DWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final angle = _controller.value * 2 * pi;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: CustomPaint(
            painter: _AvatarPainter(
              problemArea: widget.problemArea,
              highlight: widget.hasIssue,
            ),
            child: const SizedBox(
              width: 180,
              height: 220,
            ),
          ),
        );
      },
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final AvatarProblemArea problemArea;
  final bool highlight;

  _AvatarPainter({required this.problemArea, required this.highlight});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final top = size.height * 0.15;

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.medBlue, Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final outlinePaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final headRadius = size.width * 0.16;
    final headCenter = Offset(centerX, top + headRadius);
    canvas.drawCircle(headCenter, headRadius, bodyPaint);
    canvas.drawCircle(headCenter, headRadius, outlinePaint);

    final bodyPath = Path()
      ..moveTo(centerX - headRadius * 0.9, headCenter.dy + headRadius * 0.7)
      ..quadraticBezierTo(
        centerX,
        size.height * 0.55,
        centerX + headRadius * 0.9,
        headCenter.dy + headRadius * 0.7,
      )
      ..lineTo(centerX + headRadius * 0.55, size.height * 0.9)
      ..quadraticBezierTo(
        centerX,
        size.height * 0.96,
        centerX - headRadius * 0.55,
        size.height * 0.9,
      )
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, outlinePaint);

    if (highlight && problemArea == AvatarProblemArea.heart) {
      final heartCenter = Offset(centerX, size.height * 0.52);
      final heartPaint = Paint()
        ..color = AppColors.medBurgundy.withOpacity(0.75)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(heartCenter, headRadius * 0.45, heartPaint);

      final glowPaint = Paint()
        ..color = AppColors.medBurgundy.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      canvas.drawCircle(heartCenter, headRadius * 0.7, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
