import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/workout_logger_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/tools_screen.dart';
import 'screens/history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: const TamrinApp(),
    ),
  );
}

class TamrinApp extends StatelessWidget {
  const TamrinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اپلیکیشن تمرین',
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF1E1E1E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onStartWorkoutTab: () => setState(() => _currentIndex = 1)),
      const WorkoutLoggerScreen(),
      const ExercisesScreen(),
      const ToolsScreen(),
      const HistoryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF1A1A1A),
        indicatorColor: const Color(0xFF00E5FF).withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'خانه'),
          NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'تمرین'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'حرکات'),
          NavigationDestination(icon: Icon(Icons.handyman_outlined), selectedIcon: Icon(Icons.handyman), label: 'ابزارها'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'تاریخچه'),
        ],
      ),
    );
  }
}
