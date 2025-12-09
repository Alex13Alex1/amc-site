import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/avatar_3d_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Заглушечные данные – позже будут приходить из backend
    const overallScore = 78;
    const heartScore = 65;
    const energyScore = 82;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDICINAL AI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ваше состояние сегодня', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Общий индекс здоровья на основе последних анализов и данных. '
              'Ниже – ключевые зоны.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 3,
                  child: Avatar3DWidget(
                    problemArea: AvatarProblemArea.heart,
                    hasIssue: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _ScoreCard(
                        label: 'Общий индекс',
                        value: overallScore,
                        color: AppColors.medBlue,
                      ),
                      const SizedBox(height: 8),
                      _ScoreCard(
                        label: 'Зона сердца',
                        value: heartScore,
                        color: AppColors.medBurgundy,
                      ),
                      const SizedBox(height: 8),
                      _ScoreCard(
                        label: 'Энергия и восстановление',
                        value: energyScore,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Text('Динамика показателей (кратко)', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: SizedBox(
                height: 120,
                child: CustomPaint(
                  painter: _MiniTrendPainter(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '↑ Лёгкий рост общего индекса\n↓ Стресс постепенно снижается',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/report');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.medBlue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Открыть подробный отчёт'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ScoreCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: value / 100,
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation(color),
                    backgroundColor: color.withOpacity(0.1),
                  ),
                  Center(
                    child: Text(
                      '$value',
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.medBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintArea = Paint()
      ..color = AppColors.medBlue.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];
    final rndValues = [0.4, 0.45, 0.5, 0.6, 0.58, 0.65, 0.7];

    for (int i = 0; i < rndValues.length; i++) {
      final x = size.width * (i / (rndValues.length - 1));
      final y = size.height * (1 - rndValues[i]);
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(fillPath, paintArea);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
