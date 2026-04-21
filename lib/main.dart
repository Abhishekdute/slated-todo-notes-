import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/local_data_service.dart';
import 'models/todo_model.dart';
import 'models/note_model.dart';
import 'view/home/home_view.dart';
import 'core/theme/theme_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/user/user_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter<TodoModel>(TodoModelAdapter());
  Hive.registerAdapter<NoteModel>(NoteModelAdapter());
  await Hive.openBox<TodoModel>("todoBox");
  await Hive.openBox<NoteModel>("noteBox");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => UserManager()),
      ],
      child: BaseWidget(child: const SlatedApp()),
    ),
  );
}

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required super.child});
  
  final LocalDataService dataService = LocalDataService();

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) return base;
    throw StateError('Could not find ancestor widget of type BaseWidget');
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class SlatedApp extends StatelessWidget {
  const SlatedApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slated',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeView(),
    );
  }
}
