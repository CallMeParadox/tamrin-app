import '../models/exercise.dart';

class ExerciseDatabase {
  static const List<Exercise> defaultExercises = [
    // سینه (Chest)
    Exercise(
      id: 'chest_bench_press',
      nameFa: 'پرس سینه هالتر',
      nameEn: 'Barbell Bench Press',
      category: 'سینه',
      equipment: 'هالتر',
      tips: 'کتف‌ها را به عقب جمع کنید، قوس ملایم در کمر داشته باشید و مچ دست‌ها را نشکنید.',
    ),
    Exercise(
      id: 'chest_incline_dumbbell',
      nameFa: 'پرس بالا سینه دمبل',
      nameEn: 'Incline Dumbbell Press',
      category: 'سینه',
      equipment: 'دمبل',
      tips: 'زاویه نیمکت بین ۳۰ تا ۴۵ درجه تنظیم شود. در پایین حرکت کشش کامل و در بالا انقباض سینه را حفظ کنید.',
    ),
    Exercise(
      id: 'chest_dips',
      nameFa: 'پارالل (دیپ)',
      nameEn: 'Chest Dips',
      category: 'سینه',
      equipment: 'وزن بدن',
      tips: 'برای تمرکز روی زیرسینه، تنه را کمی به جلو متمایل کنید و آرنج‌ها را به بیرون باز کنید.',
    ),
    Exercise(
      id: 'chest_cable_fly',
      nameFa: 'کراس اوور سیم‌کش',
      nameEn: 'Cable Fly / Crossover',
      category: 'سینه',
      equipment: 'سیم‌کش',
      tips: 'آرنج‌ها را کمی خم نگه دارید و با انقباض بخش داخلی سینه دست‌ها را به هم نزدیک کنید.',
    ),

    // زیربغل و پشت (Back)
    Exercise(
      id: 'back_deadlift',
      nameFa: 'ددلیفت سنتی',
      nameEn: 'Conventional Deadlift',
      category: 'زیربغل و پشت',
      equipment: 'هالتر',
      tips: 'ستون فقرات را کاملاً صاف نگه دارید، میله نزدیک به ساق پا حرکت کند و با باسن بالا بکشید.',
    ),
    Exercise(
      id: 'back_barbell_row',
      nameFa: 'زیربغل هالتر خم',
      nameEn: 'Barbell Bent Over Row',
      category: 'زیربغل و پشت',
      equipment: 'هالتر',
      tips: 'تنه را در زاویه ۴۵ درجه قفل کنید، میله را به سمت ناف بکشید و کتف‌ها را در بالا به هم بفشارید.',
    ),
    Exercise(
      id: 'back_lat_pulldown',
      nameFa: 'زیربغل سیم‌کش از جلو (لت)',
      nameEn: 'Lat Pulldown',
      category: 'زیربغل و پشت',
      equipment: 'دستگاه',
      tips: 'از پرتاب کردن وزن و عقب رفتن بیش از حد خودداری کنید؛ میله را تا بالای سینه پایین بیاورید.',
    ),
    Exercise(
      id: 'back_seated_cable_row',
      nameFa: 'قایقی سیم‌کش',
      nameEn: 'Seated Cable Row',
      category: 'زیربغل و پشت',
      equipment: 'سیم‌کش',
      tips: 'کمر کاملاً صاف، سینه جلو و دستگیره به سمت انتهای شکم کشیده شود.',
    ),

    // سرشانه (Shoulders)
    Exercise(
      id: 'shoulder_overhead_press',
      nameFa: 'پرس سرشانه هالتر نظامی',
      nameEn: 'Overhead Press (OHP)',
      category: 'سرشانه',
      equipment: 'هالتر',
      tips: 'شکم و باسن را منقبض نگه دارید تا کمر قوس بر ندارد. میله در یک خط مستقیم بالا برود.',
    ),
    Exercise(
      id: 'shoulder_lateral_raise',
      nameFa: 'نشر از جانب دمبل',
      nameEn: 'Dumbbell Lateral Raise',
      category: 'سرشانه',
      equipment: 'دمبل',
      tips: 'آرنج‌ها کمی جلوتر از خط بدن (صفحه اسکپشن) حرکت کنند و دست بالاتر از شانه نرود.',
    ),
    Exercise(
      id: 'shoulder_face_pull',
      nameFa: 'فیس پول سیم‌کش',
      nameEn: 'Face Pull',
      category: 'سرشانه',
      equipment: 'سیم‌کش',
      tips: 'طناب را به سمت پیشانی بکشید و با چرخش خارجی دست‌ها شانه خلفی و روتاتور کاف را درگیر کنید.',
    ),

    // بازو (Arms)
    Exercise(
      id: 'biceps_barbell_curl',
      nameFa: 'جلو بازو هالتر ایستاده',
      nameEn: 'Barbell Bicep Curl',
      category: 'جلو بازو',
      equipment: 'هالتر',
      tips: 'آرنج‌ها را کنار پهلوها ثابت نگه دارید و از تاب دادن کمر اکیداً خودداری کنید.',
    ),
    Exercise(
      id: 'biceps_hammer_curl',
      nameFa: 'جلو بازو چکشی دمبل',
      nameEn: 'Hammer Curl',
      category: 'جلو بازو',
      equipment: 'دمبل',
      tips: 'برای تقویت براکیالیس و ساعد دست‌ها در حالت موازی رو به هم نگه داشته شوند.',
    ),
    Exercise(
      id: 'triceps_skull_crusher',
      nameFa: 'پشت بازو هالتر خوابیده (جمجمه شکن)',
      nameEn: 'Skull Crusher',
      category: 'پشت بازو',
      equipment: 'هالتر',
      tips: 'هالتر به سمت بالای سر پایین برود تا کشش سر بلند پشت بازو حداکثر شود.',
    ),
    Exercise(
      id: 'triceps_rope_pushdown',
      nameFa: 'پشت بازو سیم‌کش با طناب',
      nameEn: 'Triceps Rope Pushdown',
      category: 'پشت بازو',
      equipment: 'سیم‌کش',
      tips: 'در انتهای دامنه حرکت طناب را به دو طرف باز کنید تا اوج انقباض ایجاد شود.',
    ),

    // پا (Legs)
    Exercise(
      id: 'legs_barbell_squat',
      nameFa: 'اسکوات هالتر از پشت',
      nameEn: 'Barbell Back Squat',
      category: 'چهارسر ران',
      equipment: 'هالتر',
      tips: 'زانوها در راستای نوک انگشتان شست پا خم شوند، لگن زیر سطح زانو قرار گیرد و سینه بالا باشد.',
    ),
    Exercise(
      id: 'legs_leg_press',
      nameFa: 'پرس پا دستگاه',
      nameEn: 'Leg Press',
      category: 'چهارسر ران',
      equipment: 'دستگاه',
      tips: 'در بالای حرکت زانوها را هرگز قفل نکنید؛ باسن از پشتی صندلی جدا نشود.',
    ),
    Exercise(
      id: 'legs_romanian_deadlift',
      nameFa: 'ددلیفت رومانیایی (RDL)',
      nameEn: 'Romanian Deadlift',
      category: 'همسترینگ',
      equipment: 'هالتر',
      tips: 'زانوها کمی خمیده، لگن به عقب هل داده شود تا کشش کامل در همسترینگ احساس شود.',
    ),
    Exercise(
      id: 'legs_lying_leg_curl',
      nameFa: 'پشت پا دستگاه خوابیده',
      nameEn: 'Lying Leg Curl',
      category: 'همسترینگ',
      equipment: 'دستگاه',
      tips: 'حرکت را در مسیر بازگشت کنترل‌شده و آرام اجرا کنید.',
    ),
    Exercise(
      id: 'legs_standing_calf_raise',
      nameFa: 'ساق پا ایستاده دستگاه',
      nameEn: 'Standing Calf Raise',
      category: 'ساق',
      equipment: 'دستگاه',
      tips: 'در پایین حرکت مکث ۲ ثانیه‌ای برای کشش و در بالا انقباض کامل داشته باشید.',
    ),

    // شکم (Abs)
    Exercise(
      id: 'abs_hanging_leg_raise',
      nameFa: 'زیر شکم بارفیکس (آویزان)',
      nameEn: 'Hanging Leg / Knee Raise',
      category: 'شکم',
      equipment: 'وزن بدن',
      tips: 'به جای صرفاً بالا آوردن پا، لگن را به سمت بالا و داخل شکم بچرخانید.',
    ),
    Exercise(
      id: 'abs_cable_crunch',
      nameFa: 'کرانچ سیم‌کش زانو زده',
      nameEn: 'Cable Kneeling Crunch',
      category: 'شکم',
      equipment: 'سیم‌کش',
      tips: 'باسن ثابت بماند و با خم کردن ستون فقرات عضلات راست شکمی را منقبض کنید.',
    ),
  ];

  static List<String> get categories => [
        'همه',
        'سینه',
        'زیربغل و پشت',
        'سرشانه',
        'چهارسر ران',
        'همسترینگ',
        'جلو بازو',
        'پشت بازو',
        'ساق',
        'شکم',
      ];
}
