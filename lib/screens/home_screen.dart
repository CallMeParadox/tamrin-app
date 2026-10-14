import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/exercise_db.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartWorkoutTab;

  const HomeScreen({super.key, required this.onStartWorkoutTab});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final prs = provider.personalRecords;
    final weeklyVolume = provider.weeklyMuscleSets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تمرین هوشمند', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بنر شروع سریع تمرین
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('آماده تمرین امروز هستی؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                const Text('ثبت دقیق وزنه‌ها، ست‌ها و شکستن رکوردهای قبلی', style: TextStyle(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0077B6),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('شروع تمرین آزاد', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    provider.startNewWorkout();
                    onStartWorkoutTab();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // روال‌های تمرینی ۳ روزه آماده
          const Text('برنامه تمرینی ۳ روزه استاندارد:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRoutineCard(
                  context,
                  title: 'روز ۱: سینه و جلو بازو',
                  desc: 'پرس سینه هالتر، بالا سینه دمبل، پارالل، جلو بازو',
                  color: Colors.deepPurple.shade700,
                  onStart: () {
                    final exercises = provider.exercises.where((e) =>
                      e.id == 'chest_bench_press' ||
                      e.id == 'chest_incline_dumbbell' ||
                      e.id == 'chest_dips' ||
                      e.id == 'biceps_barbell_curl'
                    ).toList();
                    provider.startRoutine('روز ۱: سینه و جلو بازو', exercises);
                    onStartWorkoutTab();
                  },
                ),
                const SizedBox(width: 12),
                _buildRoutineCard(
                  context,
                  title: 'روز ۲: زیربغل و پشت بازو',
                  desc: 'ددلیفت، زیربغل هالتر خم، لت سیم‌کش، پشت بازو طناب',
                  color: Colors.teal.shade800,
                  onStart: () {
                    final exercises = provider.exercises.where((e) =>
                      e.id == 'back_deadlift' ||
                      e.id == 'back_barbell_row' ||
                      e.id == 'back_lat_pulldown' ||
                      e.id == 'triceps_rope_pushdown'
                    ).toList();
                    provider.startRoutine('روز ۲: زیربغل و پشت بازو', exercises);
                    onStartWorkoutTab();
                  },
                ),
                const SizedBox(width: 12),
                _buildRoutineCard(
                  context,
                  title: 'روز ۳: سرشانه، پا و شکم',
                  desc: 'اسکوات، پرس پا، پرس نظامی، زیر شکم بارفیکس',
                  color: Colors.indigo.shade800,
                  onStart: () {
                    final exercises = provider.exercises.where((e) =>
                      e.id == 'legs_barbell_squat' ||
                      e.id == 'legs_leg_press' ||
                      e.id == 'shoulder_overhead_press' ||
                      e.id == 'abs_hanging_leg_raise'
                    ).toList();
                    provider.startRoutine('روز ۳: سرشانه و پا', exercises);
                    onStartWorkoutTab();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // حجم هفتگی عضلات (تعداد ست‌های موثر در هفته جاری)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('حجم هفتگی عضلات (ست‌های موثر)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('هدف: ۱۰-۲۰ ست', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: weeklyVolume.entries.map((entry) {
                  final sets = entry.value;
                  final double progress = (sets / 18.0).clamp(0.0, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(fontSize: 13)),
                            Text('$sets ست', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF00E5FF))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white12,
                          color: progress >= 0.5 ? const Color(0xFF00E676) : const Color(0xFF00E5FF),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // رکوردهای شخصی من (PRs)
          if (prs.isNotEmpty) ...[
            const Text('رکوردهای شخصی اخیر (PRs):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...prs.values.take(5).map((pr) => Card(
              color: const Color(0xFF1E1E1E),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF00E676),
                  foregroundColor: Colors.black,
                  child: Icon(Icons.emoji_events),
                ),
                title: Text(pr.exerciseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('بیشترین وزنه: ${pr.maxWeight} kg | تخمین 1RM: ${pr.bestEstimated1RM.toStringAsFixed(1)} kg'),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildRoutineCard(BuildContext context, {required String title, required String desc, required Color color, required VoidCallback onStart}) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 12, color: Colors.white70), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          FilledButton.tonal(
            style: FilledButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
            onPressed: onStart,
            child: const Text('شروع این روتین'),
          ),
        ],
      ),
    );
  }
}
