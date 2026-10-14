import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/workout_session.dart';
import '../models/workout_set.dart';
import 'exercise_db.dart';

class PersonalRecord {
  final String exerciseId;
  final String exerciseName;
  final double maxWeight;
  final double maxVolume;
  final double bestEstimated1RM;

  PersonalRecord({
    required this.exerciseId,
    required this.exerciseName,
    required this.maxWeight,
    required this.maxVolume,
    required this.bestEstimated1RM,
  });

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'maxWeight': maxWeight,
        'maxVolume': maxVolume,
        'bestEstimated1RM': bestEstimated1RM,
      };

  factory PersonalRecord.fromJson(Map<String, dynamic> json) => PersonalRecord(
        exerciseId: json['exerciseId'] as String,
        exerciseName: json['exerciseName'] as String,
        maxWeight: (json['maxWeight'] as num).toDouble(),
        maxVolume: (json['maxVolume'] as num).toDouble(),
        bestEstimated1RM: (json['bestEstimated1RM'] as num).toDouble(),
      );
}

class WorkoutProvider with ChangeNotifier {
  static const String _workoutsKey = 'saved_workouts_v1';
  static const String _activeWorkoutKey = 'active_workout_draft_v1';

  List<WorkoutSession> _history = [];
  WorkoutSession? _activeWorkout;
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  List<WorkoutSession> get history => _history;
  WorkoutSession? get activeWorkout => _activeWorkout;
  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  WorkoutProvider() {
    _init();
  }

  Future<void> _init() async {
    _exercises = List.from(ExerciseDatabase.defaultExercises);
    await _loadFromPrefs();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // تاریخچه تمرین‌ها
    final historyStr = prefs.getString(_workoutsKey);
    if (historyStr != null && historyStr.isNotEmpty) {
      try {
        final List decoded = jsonDecode(historyStr);
        _history = decoded.map((item) => WorkoutSession.fromJson(item)).toList();
      } catch (e) {
        debugPrint('Error loading history: $e');
      }
    }

    // تمرین فعال در حال انجام
    final activeStr = prefs.getString(_activeWorkoutKey);
    if (activeStr != null && activeStr.isNotEmpty) {
      try {
        _activeWorkout = WorkoutSession.fromJson(jsonDecode(activeStr));
      } catch (e) {
        debugPrint('Error loading active workout: $e');
      }
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_history.map((w) => w.toJson()).toList());
    await prefs.setString(_workoutsKey, jsonStr);
  }

  Future<void> _saveActiveWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    if (_activeWorkout == null) {
      await prefs.remove(_activeWorkoutKey);
    } else {
      await prefs.setString(_activeWorkoutKey, jsonEncode(_activeWorkout!.toJson()));
    }
  }

  void startNewWorkout({String title = 'تمرین آزاد'}) {
    _activeWorkout = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: DateTime.now(),
      exercises: [],
    );
    _saveActiveWorkout();
    notifyListeners();
  }

  void startRoutine(String routineName, List<Exercise> exerciseList) {
    _activeWorkout = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: routineName,
      date: DateTime.now(),
      exercises: exerciseList.map((e) => WorkoutExercise(
        exercise: e,
        sets: [
          WorkoutSet(setNumber: 1, type: SetType.warmup, weight: 20, reps: 15),
          WorkoutSet(setNumber: 2, type: SetType.normal, weight: 40, reps: 10),
          WorkoutSet(setNumber: 3, type: SetType.normal, weight: 40, reps: 10),
        ],
      )).toList(),
    );
    _saveActiveWorkout();
    notifyListeners();
  }

  void addExerciseToActiveWorkout(Exercise exercise) {
    if (_activeWorkout == null) {
      startNewWorkout();
    }
    _activeWorkout!.exercises.add(
      WorkoutExercise(
        exercise: exercise,
        sets: [WorkoutSet(setNumber: 1, type: SetType.normal, weight: 0, reps: 0)],
      ),
    );
    _saveActiveWorkout();
    notifyListeners();
  }

  void removeExerciseFromActiveWorkout(int exerciseIndex) {
    if (_activeWorkout != null && exerciseIndex < _activeWorkout!.exercises.length) {
      _activeWorkout!.exercises.removeAt(exerciseIndex);
      _saveActiveWorkout();
      notifyListeners();
    }
  }

  void addSet(int exerciseIndex) {
    if (_activeWorkout != null && exerciseIndex < _activeWorkout!.exercises.length) {
      final sets = _activeWorkout!.exercises[exerciseIndex].sets;
      final lastSet = sets.isNotEmpty ? sets.last : null;
      sets.add(
        WorkoutSet(
          setNumber: sets.length + 1,
          type: SetType.normal,
          weight: lastSet?.weight ?? 0.0,
          reps: lastSet?.reps ?? 0,
        ),
      );
      _saveActiveWorkout();
      notifyListeners();
    }
  }

  void removeSet(int exerciseIndex, int setIndex) {
    if (_activeWorkout != null && exerciseIndex < _activeWorkout!.exercises.length) {
      final sets = _activeWorkout!.exercises[exerciseIndex].sets;
      if (sets.length > 1) {
        sets.removeAt(setIndex);
        for (int i = 0; i < sets.length; i++) {
          sets[i].setNumber = i + 1;
        }
        _saveActiveWorkout();
        notifyListeners();
      }
    }
  }

  void toggleSetComplete(int exerciseIndex, int setIndex) {
    if (_activeWorkout != null && exerciseIndex < _activeWorkout!.exercises.length) {
      final set = _activeWorkout!.exercises[exerciseIndex].sets[setIndex];
      set.isCompleted = !set.isCompleted;
      _saveActiveWorkout();
      notifyListeners();
    }
  }

  void updateSet(int exerciseIndex, int setIndex, {double? weight, int? reps, SetType? type, double? rpe}) {
    if (_activeWorkout != null && exerciseIndex < _activeWorkout!.exercises.length) {
      final set = _activeWorkout!.exercises[exerciseIndex].sets[setIndex];
      if (weight != null) set.weight = weight;
      if (reps != null) set.reps = reps;
      if (type != null) set.type = type;
      if (rpe != null) set.rpe = rpe;
      _saveActiveWorkout();
      notifyListeners();
    }
  }

  Future<void> finishWorkout() async {
    if (_activeWorkout == null) return;
    _history.insert(0, _activeWorkout!);
    _activeWorkout = null;
    await _saveHistory();
    await _saveActiveWorkout();
    notifyListeners();
  }

  void cancelWorkout() {
    _activeWorkout = null;
    _saveActiveWorkout();
    notifyListeners();
  }

  // محاسبه رکوردهای شخصی (PR) برای هر حرکت
  Map<String, PersonalRecord> get personalRecords {
    final Map<String, PersonalRecord> records = {};

    for (var session in _history) {
      for (var ex in session.exercises) {
        for (var s in ex.sets.where((s) => s.isCompleted)) {
          final id = ex.exercise.id;
          final existing = records[id];

          final currentWeight = s.weight;
          final currentVolume = s.volume;
          final current1RM = s.estimated1RM;

          if (existing == null) {
            records[id] = PersonalRecord(
              exerciseId: id,
              exerciseName: ex.exercise.nameFa,
              maxWeight: currentWeight,
              maxVolume: currentVolume,
              bestEstimated1RM: current1RM,
            );
          } else {
            records[id] = PersonalRecord(
              exerciseId: id,
              exerciseName: ex.exercise.nameFa,
              maxWeight: currentWeight > existing.maxWeight ? currentWeight : existing.maxWeight,
              maxVolume: currentVolume > existing.maxVolume ? currentVolume : existing.maxVolume,
              bestEstimated1RM: current1RM > existing.bestEstimated1RM ? current1RM : existing.bestEstimated1RM,
            );
          }
        }
      }
    }
    return records;
  }

  // حجم هفتگی عضلات (تعداد ست‌های موثر در ۷ روز گذشته)
  Map<String, int> get weeklyMuscleSets {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    final Map<String, int> counts = {
      'سینه': 0,
      'زیربغل و پشت': 0,
      'سرشانه': 0,
      'چهارسر ران': 0,
      'همسترینگ': 0,
      'جلو بازو': 0,
      'پشت بازو': 0,
      'ساق': 0,
      'شکم': 0,
    };

    for (var session in _history) {
      if (session.date.isAfter(oneWeekAgo)) {
        for (var ex in session.exercises) {
          final cat = ex.exercise.category;
          final validSets = ex.sets.where((s) => s.isCompleted && s.type != SetType.warmup).length;
          if (counts.containsKey(cat)) {
            counts[cat] = (counts[cat] ?? 0) + validSets;
          }
        }
      }
    }

    return counts;
  }
}
