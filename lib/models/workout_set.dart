enum SetType {
  normal,   // ست عادی
  warmup,   // W: گرم کردن
  dropset,  // D: دراپ‌ست
  failure,  // F: تا مرز شکست
}

class WorkoutSet {
  int setNumber;
  SetType type;
  double weight; // کیلوگرم
  int reps;     // تعداد تکرار
  double? rpe;  // 6 - 10
  bool isCompleted;

  WorkoutSet({
    required this.setNumber,
    this.type = SetType.normal,
    this.weight = 0.0,
    this.reps = 0,
    this.rpe,
    this.isCompleted = false,
  });

  // فرمول Epley برای تخمین یک تکرار بیشینه (1RM)
  double get estimated1RM {
    if (weight <= 0 || reps <= 0) return 0.0;
    if (reps == 1) return weight;
    return weight * (1.0 + (reps / 30.0));
  }

  // حجم ست (Weight * Reps)
  double get volume => weight * reps;

  String get typeLabel {
    switch (type) {
      case SetType.warmup:
        return 'W';
      case SetType.dropset:
        return 'D';
      case SetType.failure:
        return 'F';
      case SetType.normal:
        return '$setNumber';
    }
  }

  Map<String, dynamic> toJson() => {
        'setNumber': setNumber,
        'type': type.name,
        'weight': weight,
        'reps': reps,
        'rpe': rpe,
        'isCompleted': isCompleted,
      };

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
        setNumber: json['setNumber'] as int? ?? 1,
        type: SetType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => SetType.normal,
        ),
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
        reps: json['reps'] as int? ?? 0,
        rpe: (json['rpe'] as num?)?.toDouble(),
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}
