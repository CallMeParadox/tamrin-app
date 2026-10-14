import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final history = provider.history;

    if (history.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('تاریخچه تمرین‌ها'), centerTitle: true),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 72, color: Colors.white24),
              SizedBox(height: 16),
              Text('هنوز تمرینی ثبت نشده است.', style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final totalVolumeSum = history.fold(0.0, (sum, w) => sum + w.totalVolume);

    return Scaffold(
      appBar: AppBar(title: const Text('تاریخچه تمرین‌ها'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // آمار کلی
          Card(
            color: const Color(0xFF1E1E1E),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('تعداد تمرین‌ها', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('${history.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00E5FF))),
                    ],
                  ),
                  Container(height: 36, width: 1, color: Colors.white12),
                  Column(
                    children: [
                      const Text('مجموع تناژ جابجا شده', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('${(totalVolumeSum / 1000).toStringAsFixed(1)} تن', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00E676))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // لیست تمرین‌های گذشته
          ...history.map((workout) {
            final dateStr = DateFormat('yyyy/MM/dd – HH:mm').format(workout.date);
            return Card(
              color: const Color(0xFF1E1E1E),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: const CircleAvatar(
                  backgroundColor: Colors.white10,
                  child: Icon(Icons.fitness_center, color: Color(0xFF00E5FF)),
                ),
                title: Text(workout.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text('$dateStr | ${workout.totalVolume.toStringAsFixed(0)} kg حجم کل', style: const TextStyle(fontSize: 12, color: Colors.white54)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        ...workout.exercises.map((ex) {
                          final setsSummary = ex.sets
                              .where((s) => s.isCompleted)
                              .map((s) => '${s.weight}kg×${s.reps}')
                              .join('  |  ');

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(ex.exercise.nameFa, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    setsSummary.isNotEmpty ? setsSummary : 'ست ثبت نشده',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
