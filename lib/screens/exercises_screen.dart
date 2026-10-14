import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../services/exercise_db.dart';
import '../services/storage_service.dart';

class ExercisesScreen extends StatefulWidget {
  final bool selectMode;
  final Function(Exercise)? onSelected;

  const ExercisesScreen({super.key, this.selectMode = false, this.onSelected});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  String _selectedCategory = 'همه';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final allExercises = provider.exercises;

    final filtered = allExercises.where((ex) {
      final matchCategory = _selectedCategory == 'همه' || ex.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          ex.nameFa.contains(_searchQuery) ||
          ex.nameEn.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectMode ? 'انتخاب حرکت تمرینی' : 'کتابخانه حرکات'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // فیلد جستجو
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'جستجو در نام فارسی یا انگلیسی حرکت...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // چیپ‌های دسته‌بندی
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: ExerciseDatabase.categories.length,
              itemBuilder: (context, index) {
                final cat = ExerciseDatabase.categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFF00E5FF).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF00E5FF),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // لیست حرکات
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('حرکتی با این مشخصات یافت نشد.', style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemBuilder: (context, index) {
                      final ex = filtered[index];
                      return Card(
                        color: const Color(0xFF1E1E1E),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(ex.nameFa, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ex.nameEn, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(ex.category, style: const TextStyle(fontSize: 11, color: Color(0xFF00E5FF))),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(ex.equipment, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: widget.selectMode
                              ? IconButton.filled(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    if (widget.onSelected != null) {
                                      widget.onSelected!(ex);
                                    }
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.info_outline, color: Color(0xFF00E676)),
                                  onPressed: () => _showExerciseDetails(context, ex),
                                ),
                          onTap: () {
                            if (widget.selectMode && widget.onSelected != null) {
                              widget.onSelected!(ex);
                            } else {
                              _showExerciseDetails(context, ex);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails(BuildContext context, Exercise ex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ex.nameFa, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(ex.nameEn, style: const TextStyle(fontSize: 14, color: Colors.white54)),
              const Divider(height: 24),
              Row(
                children: [
                  const Text('عضله هدف: ', style: TextStyle(color: Colors.white70)),
                  Text(ex.category, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E5FF))),
                  const SizedBox(width: 20),
                  const Text('تجهیزات: ', style: TextStyle(color: Colors.white70)),
                  Text(ex.equipment, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('نکات بیومکانیکی و ایمنی اجرای صحیح:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E676))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  ex.tips.isNotEmpty ? ex.tips : 'حرکت را با کنترل کامل و بدون پرتاب وزنه در تمام دامنه انجام دهید.',
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('بستن'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
