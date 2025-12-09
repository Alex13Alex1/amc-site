import 'package:flutter/material.dart';
import '../theme.dart';

class DetailedReportScreen extends StatelessWidget {
  const DetailedReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final vitamins = [
      {
        'name': 'Витамин D',
        'status': 'Ниже оптимального',
        'recommendation':
            'Может быть связан с недостатком солнца и питания. Обсудите с врачом возможный приём добавок.',
      },
      {
        'name': 'Витамин B12',
        'status': 'В норме',
        'recommendation':
            'Поддерживайте разнообразное питание, особенно продукты животного происхождения или обогащённые продукты.',
      },
      {
        'name': 'Магний',
        'status': 'Граница нормы',
        'recommendation':
            'Возможна связь со стрессом и качеством сна. Обратите внимание на сон и продукты, богатые магнием.',
      },
    ];

    final risks = [
      {
        'name': 'Нагрузка на сердце',
        'level': 'умеренная',
        'explanation':
            'Некоторые показатели намекают, что сердечно‑сосудистая система работает с лишним напряжением.',
      },
      {
        'name': 'Воспалительный фон',
        'level': 'низкий',
        'explanation':
            'В целом маркеры воспаления спокойные, серьёзных рисков по ним не видно.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Подробный отчёт'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Краткое резюме', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Общий профиль выглядит умеренно стабильным. Есть отдельные зоны, которые стоит улучшить через питание, сон и нагрузку. '
            'Ниже — детальный разбор простым языком.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Зона сердца',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Сердце получает умеренную нагрузку. Это не диагноз и не “приговор”, а сигнал присмотреться к режиму.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                const _BulletPoint(text: 'Старайтесь держать регулярную, но не экстремальную активность.'),
                const _BulletPoint(text: 'Следите за качеством сна — восстановление важно для сердечно‑сосудистой системы.'),
                const _BulletPoint(text: 'Если появляются неприятные ощущения, обязательно обсудите это с врачом.'),
              ],
            ),
          ),
          Text('Факторы риска (простым языком)', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          ...risks.map((r) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['name']!, style: textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text('Уровень: ${r['level']}', style: textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Text(r['explanation']!, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
          Text('Витамины и минералы', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                AppColors.medBlue.withOpacity(0.08),
              ),
              columns: const [
                DataColumn(label: Text('Нутриент')),
                DataColumn(label: Text('Статус')),
              ],
              rows: vitamins
                  .map(
                    (v) => DataRow(
                      cells: [
                        DataCell(Text(v['name']!)),
                        DataCell(Text(v['status']!)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          ...vitamins.map(
            (v) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v['name']!, style: textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(v['recommendation']!, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Образ жизни и алгоритмы улучшения', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const _SectionCard(
            title: 'Простой план действий',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BulletPoint(text: '1. Сон: постарайтесь держать примерно одинаковое время отхода ко сну и подъёма.'),
                _BulletPoint(text: '2. Движение: добавьте 15–20 минут спокойной активности (шаги, прогулка) в те дни, где её мало.'),
                _BulletPoint(text: '3. Питание: добавьте продукты, богатые витамином D и магнием (рыба, яйца, орехи, зелень).'),
                _BulletPoint(text: '4. БАДы: любые добавки лучше подбирать совместно с врачом, опираясь на реальные анализы.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Важно: MEDICINAL AI не ставит диагнозы и не заменяет очный приём врача. '
            'Все выводы носят информационный характер.',
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
