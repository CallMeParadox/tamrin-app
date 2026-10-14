import 'dart:async';
import 'package:flutter/material.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ابزارهای پیشرفته تمرین'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center), text: 'صفحات هالتر'),
            Tab(icon: Icon(Icons.calculate), text: 'محاسبه 1RM'),
            Tab(icon: Icon(Icons.timer), text: 'تایمر استراحت'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PlateCalculatorView(),
          OneRepMaxCalculatorView(),
          RestTimerView(),
        ],
      ),
    );
  }
}

// 1. محاسبه‌گر صفحات هالتر (Plate Calculator)
class PlateCalculatorView extends StatefulWidget {
  const PlateCalculatorView({super.key});

  @override
  State<PlateCalculatorView> createState() => _PlateCalculatorViewState();
}

class _PlateCalculatorViewState extends State<PlateCalculatorView> {
  double _barWeight = 20.0;
  double _targetWeight = 100.0;
  final List<double> _availablePlates = [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];

  Map<double, int> _calculatePlatesPerSide() {
    double remainingWeight = (_targetWeight - _barWeight) / 2.0;
    if (remainingWeight <= 0) return {};

    final Map<double, int> platesNeeded = {};
    for (var plate in _availablePlates) {
      if (remainingWeight >= plate) {
        int count = (remainingWeight / plate).floor();
        platesNeeded[plate] = count;
        remainingWeight -= (count * plate);
      }
    }
    return platesNeeded;
  }

  Color _getPlateColor(double weight) {
    if (weight >= 25) return Colors.red.shade700;
    if (weight >= 20) return Colors.blue.shade700;
    if (weight >= 15) return Colors.yellow.shade800;
    if (weight >= 10) return Colors.green.shade700;
    if (weight >= 5) return Colors.white70;
    if (weight >= 2.5) return Colors.black54;
    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final plates = _calculatePlatesPerSide();
    final weightPerSide = (_targetWeight - _barWeight) > 0 ? (_targetWeight - _barWeight) / 2.0 : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('وزن کل هدف (کیلوگرم)', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    '${_targetWeight.toStringAsFixed(1)} kg',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF00E5FF)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => setState(() => _targetWeight = (_targetWeight - 5.0).clamp(_barWeight, 500.0)),
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.tonal(
                        onPressed: () => setState(() => _targetWeight = (_targetWeight - 2.5).clamp(_barWeight, 500.0)),
                        child: const Text('-2.5'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.tonal(
                        onPressed: () => setState(() => _targetWeight += 2.5),
                        child: const Text('+2.5'),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        onPressed: () => setState(() => _targetWeight += 5.0),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // انتخاب میله
          Row(
            children: [
              const Text('وزن میله هالتر: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              SegmentedButton<double>(
                segments: const [
                  ButtonSegment(value: 20.0, label: Text('۲۰ kg')),
                  ButtonSegment(value: 15.0, label: Text('۱۵ kg')),
                  ButtonSegment(value: 10.0, label: Text('۱۰ kg')),
                ],
                selected: {_barWeight},
                onSelectionChanged: (val) {
                  setState(() {
                    _barWeight = val.first;
                    if (_targetWeight < _barWeight) _targetWeight = _barWeight;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // نمایش گرافیکی و لیست صفحات هر طرف
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('صفحات مورد نیاز در هر طرف:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${weightPerSide.toStringAsFixed(2)} kg هر طرف', style: const TextStyle(color: Color(0xFF00E676))),
                    ],
                  ),
                  const Divider(height: 24),
                  if (plates.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('فقط میله خالی بدون صفحه وزنه', style: TextStyle(color: Colors.white54)),
                      ),
                    )
                  else ...[
                    // نمایش المان‌های صفحه
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: plates.entries.expand((entry) {
                        return List.generate(entry.value, (index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _getPlateColor(entry.key),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              '${entry.key} kg',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: entry.key >= 15 ? Colors.white : Colors.black87,
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ...plates.entries.map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${entry.key} کیلوگرم:', style: const TextStyle(fontSize: 14)),
                              Text('${entry.value} عدد در هر طرف (${entry.value * 2} عدد کل)', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. محاسبه‌گر 1RM (یک تکرار بیشینه با فرمول Epley)
class OneRepMaxCalculatorView extends StatefulWidget {
  const OneRepMaxCalculatorView({super.key});

  @override
  State<OneRepMaxCalculatorView> createState() => _OneRepMaxCalculatorViewState();
}

class _OneRepMaxCalculatorViewState extends State<OneRepMaxCalculatorView> {
  double _weight = 80.0;
  int _reps = 8;

  double get _oneRepMax => _weight * (1.0 + (_reps / 30.0));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('تخمین یک تکرار بیشینه (1RM - فرمول Epley)', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Text(
                    '${_oneRepMax.toStringAsFixed(1)} kg',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF00E676)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text('وزنه (کیلوگرم)'),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => setState(() => _weight = (_weight - 2.5).clamp(1.0, 500.0)),
                                ),
                                Text('${_weight.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => setState(() => _weight += 2.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(height: 40, width: 1, color: Colors.white24),
                      Expanded(
                        child: Column(
                          children: [
                            const Text('تعداد تکرار'),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => setState(() => _reps = (_reps - 1).clamp(1, 30)),
                                ),
                                Text('$_reps', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => setState(() => _reps = (_reps + 1).clamp(1, 30)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('جدول درصدهای تمرینی:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF1E1E1E),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final percentages = [100, 95, 90, 85, 80, 75, 70, 60];
                final p = percentages[index];
                final targetW = _oneRepMax * (p / 100.0);
                return ListTile(
                  dense: true,
                  leading: Text('$p%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E5FF))),
                  title: Text('${targetW.toStringAsFixed(1)} کیلوگرم'),
                  trailing: Text(
                    p >= 90 ? 'قدرتی (۱-۳ تکرار)' : p >= 80 ? 'هایپرتروفی سنگین (۴-۸)' : 'هایپرتروفی / استقامت (۸-۱۲+)',
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 3. تایمر استراحت بین ست‌ها
class RestTimerView extends StatefulWidget {
  const RestTimerView({super.key});

  @override
  State<RestTimerView> createState() => _RestTimerViewState();
}

class _RestTimerViewState extends State<RestTimerView> {
  int _totalSeconds = 90;
  int _remainingSeconds = 90;
  bool _isRunning = false;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer(int seconds) {
    _timer?.cancel();
    setState(() {
      _totalSeconds = seconds;
      _remainingSeconds = seconds;
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF00E5FF)),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$minutes:$seconds',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('استراحت', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  iconSize: 32,
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 16),
                IconButton.outlined(
                  iconSize: 28,
                  onPressed: () => _resetTimer(_totalSeconds),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('زمان‌های پیشنهادی:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(label: const Text('۳۰ ثانیه'), onPressed: () => _resetTimer(30)),
                ActionChip(label: const Text('۶۰ ثانیه'), onPressed: () => _resetTimer(60)),
                ActionChip(label: const Text('۹۰ ثانیه'), onPressed: () => _resetTimer(90)),
                ActionChip(label: const Text('۲ دقیقه'), onPressed: () => _resetTimer(120)),
                ActionChip(label: const Text('۳ دقیقه'), onPressed: () => _resetTimer(180)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
