import 'exercise.dart';
import 'workout_set.dart';

class WorkoutExercise {
  final Exercise exercise;
  List<WorkoutSet> sets;
  String? notes;

  WorkoutExercise({
    required this.exercise,
    List<WorkoutSet>? sets,
    this.notes,
  }) : sets = sets ?? [WorkoutSet(setNumber: 1)];

  double get totalVolume => sets
      .where((s) => s.isCompleted)
      .fold(0.0, (sum, set) => sum + set.volume);

  int get completedSetsCount => sets.where((s) => s.isCompleted).length;

  double get best1RM => sets
      .where((s) => s.isCompleted)
      .fold(0.0, (maxVal, set) => set.estimated1RM > maxVal ? set.estimated1RM : maxVal);

  Map<String, dynamic> toJson() => {
        'exercise': exercise.toJson(),
        'sets': sets.map((s) => s.toJson()).toList(),
        'notes': notes,
      };

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) => WorkoutExercise(
        exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
        sets: (json['sets'] as List<dynamic>?)
                ?.map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
                .toList() ??
            [WorkoutSet(setNumber: 1)],
        notes: json['notes'] as String?,
      );
}

class WorkoutSession {
  final String id;
  String title;
  DateTime date;
  List<WorkoutExercise> exercises;
  int durationSeconds;
  String? note;

  WorkoutSession({
    required this.id,
    required this.title,
    required this.date,
    List<WorkoutExercise>? exercises,
    this.durationSeconds = 0,
    this.note,
  }) : exercises = exercises ?? [];

  double get totalVolume => exercises.fold(0.0, (sum, e) => sum + e.totalVolume);

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.completedSetsCount);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'durationSeconds': durationSeconds,
        'note': note,
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        id: json['id'] as String,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
        exercises: (json['exercises'] as List<dynamic>?)
                ?.map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        durationSeconds: json['durationSeconds'] as int? ?? 0,
        note: json['note'] as String?,
      );
}
