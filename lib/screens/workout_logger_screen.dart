import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../services/storage_service.dart';
import 'exercises_screen.dart';

class WorkoutLoggerScreen extends StatefulWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  State<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends State<WorkoutLoggerScreen> {
  Timer? _durationTimer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startDurationTimer();
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSecs) {
    final m = (totalSecs / 60).floor().toString().padLeft(2, '0');
    final s = (totalSecs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final active = provider.activeWorkout;

    if (active == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('ثبت تمرین')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fitness_center, size: 72, color: Colors.white24),
              const SizedBox(height: 16),
              const Text('در حال حاضر تمرین فعالی ندارید.', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('شروع تمرین جدید'),
                onPressed: () => provider.startNewWorkout(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(active.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('مدت زمان: ${_formatDuration(_seconds)}', style: const TextStyle(fontSize: 12, color: Color(0xFF00E5FF))),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _finishWorkout(context, provider),
            child: const Text('پایان تمرین', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // خلاصه سریع تمرین
          Card(
            color: const Color(0xFF1E1E1E),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('حجم کل', style: TextStyle(fontSize: 12, color: Colors.white54)),
                      const SizedBox(height: 4),
                      Text('${active.totalVolume.toStringAsFixed(1)} kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('ست‌های انجام شده', style: TextStyle(fontSize: 12, color: Colors.white54)),
                      const SizedBox(height: 4),
                      Text('${active.totalSets}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00E5FF))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // لیست حرکات تمرین
          ...List.generate(active.exercises.length, (exIndex) {
            final workoutEx = active.exercises[exIndex];
            return Card(
              color: const Color(0xFF1E1E1E),
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان حرکت و دکمه حذف
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(workoutEx.exercise.nameFa, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(workoutEx.exercise.category, style: const TextStyle(fontSize: 12, color: Color(0xFF00E5FF))),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white38),
                          onPressed: () => provider.removeExerciseFromActiveWorkout(exIndex),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // سرستون‌های جدول ست‌ها
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(width: 36, child: Text('نوع', style: TextStyle(fontSize: 12, color: Colors.white54))),
                          Expanded(flex: 3, child: Center(child: Text('کیلوگرم', style: TextStyle(fontSize: 12, color: Colors.white54)))),
                          Expanded(flex: 3, child: Center(child: Text('تکرار', style: TextStyle(fontSize: 12, color: Colors.white54)))),
                          Expanded(flex: 3, child: Center(child: Text('1RM', style: TextStyle(fontSize: 12, color: Colors.white54)))),
                          SizedBox(width: 44, child: Center(child: Icon(Icons.check, size: 16, color: Colors.white54))),
                        ],
                      ),
                    ),

                    // ردیف‌های ست‌ها
                    ...List.generate(workoutEx.sets.length, (setIndex) {
                      final set = workoutEx.sets[setIndex];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: set.isCompleted ? const Color(0xFF00E676).withOpacity(0.12) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // دکمه تغییر نوع ست (W, D, F, Normal)
                            InkWell(
                              onTap: () => _cycleSetType(provider, exIndex, setIndex, set.type),
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _getSetTypeColor(set.type),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  set.typeLabel,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ),
                            // ورودی وزن
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: TextFormField(
                                  initialValue: set.weight == 0 ? '' : set.weight.toString(),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: '0',
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onChanged: (val) {
                                    final w = double.tryParse(val) ?? 0.0;
                                    provider.updateSet(exIndex, setIndex, weight: w);
                                  },
                                ),
                              ),
                            ),
                            // ورودی تکرار
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: TextFormField(
                                  initialValue: set.reps == 0 ? '' : set.reps.toString(),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: '0',
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onChanged: (val) {
                                    final r = int.tryParse(val) ?? 0;
                                    provider.updateSet(exIndex, setIndex, reps: r);
                                  },
                                ),
                              ),
                            ),
                            // تخمین 1RM بر اساس فرمول Epley
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  set.estimated1RM > 0 ? '${set.estimated1RM.toStringAsFixed(1)}' : '-',
                                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                                ),
                              ),
                            ),
                            // تیک انجام ست (Checkmark)
                            SizedBox(
                              width: 44,
                              child: IconButton(
                                icon: Icon(
                                  set.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                                  color: set.isCompleted ? const Color(0xFF00E676) : Colors.white38,
                                ),
                                onPressed: () {
                                  provider.toggleSetComplete(exIndex, setIndex);
                                  if (!set.isCompleted) {
                                    _showQuickRestTimer(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 8),
                    // افزودن ست جدید
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('+ افزودن ست'),
                        onPressed: () => provider.addSet(exIndex),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),
          // دکمه افزودن حرکت جدید به تمرین
          FilledButton.tonalIcon(
            icon: const Icon(Icons.add),
            label: const Text('افزودن حرکت جدید'),
            onPressed: () => _openExerciseSelector(context, provider),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _cycleSetType(WorkoutProvider provider, int exIndex, int setIndex, SetType current) {
    SetType next;
    switch (current) {
      case SetType.normal:
        next = SetType.warmup;
        break;
      case SetType.warmup:
        next = SetType.dropset;
        break;
      case SetType.dropset:
        next = SetType.failure;
        break;
      case SetType.failure:
        next = SetType.normal;
        break;
    }
    provider.updateSet(exIndex, setIndex, type: next);
  }

  Color _getSetTypeColor(SetType type) {
    switch (type) {
      case SetType.normal:
        return Colors.white24;
      case SetType.warmup:
        return Colors.orange.shade800; // W: زرد/نارنجی
      case SetType.dropset:
        return Colors.blue.shade700; // D: آبی
      case SetType.failure:
        return Colors.red.shade700; // F: قرمز شکست
    }
  }

  void _openExerciseSelector(BuildContext context, WorkoutProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExercisesScreen(
          selectMode: true,
          onSelected: (selectedEx) {
            provider.addExerciseToActiveWorkout(selectedEx);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showQuickRestTimer(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.timer, color: Color(0xFF00E5FF)),
            SizedBox(width: 8),
            Text('ست با موفقیت ثبت شد! زمان استراحت شروع شد.'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _finishWorkout(BuildContext context, WorkoutProvider provider) {
    final active = provider.activeWorkout;
    if (active == null) return;

    active.durationSeconds = _seconds;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('پایان تمرین'),
        content: Text('آیا مایل به پایان و ذخیره این تمرین با حجم کل ${active.totalVolume.toStringAsFixed(1)} کیلوگرم هستید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ادامه تمرین'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.finishWorkout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تمرین با موفقیت ذخیره شد! 💪')),
                );
              }
            },
            child: const Text('ذخیره و اتمام'),
          ),
        ],
      ),
    );
  }
}
