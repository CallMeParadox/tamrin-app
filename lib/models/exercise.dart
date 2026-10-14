class Exercise {
  final String id;
  final String nameFa;
  final String nameEn;
  final String category; // سینه، زیربغل، سرشانه، بازو، پا، شکم
  final String equipment; // هالتر، دمبل، دستگاه، سیم‌کش، وزن بدن
  final String tips; // نکات بیومکانیکی و ایمنی

  const Exercise({
    required this.id,
    required this.nameFa,
    required this.nameEn,
    required this.category,
    required this.equipment,
    required this.tips,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameFa': nameFa,
        'nameEn': nameEn,
        'category': category,
        'equipment': equipment,
        'tips': tips,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        nameFa: json['nameFa'] as String,
        nameEn: json['nameEn'] as String,
        category: json['category'] as String,
        equipment: json['equipment'] as String,
        tips: json['tips'] as String? ?? '',
      );
}
