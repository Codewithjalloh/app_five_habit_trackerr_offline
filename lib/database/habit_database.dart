import 'package:app_five_habit_trackerr_offline/models/app_settings.dart';
import 'package:app_five_habit_trackerr_offline/models/habit.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

/*
  S E T U P
   */

// I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

// Save first data of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchData = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

// get first data of app start (for heatmap)
  Future<DateTime?> getFirstLaunch() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchData;
  }

/*
   CRUD OPERATIONS
   */

// List of habits
  final List<Habit> currentHabits = [];

// CREATE - add a  new habit
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }

// READ - send saved habits from db
  Future<void> readHabits() async {
    // fetch all habits from db
    List<Habit> fetchHabits = await isar.habits.where().findAll();

    // give to current habit
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);

    // update UI
    notifyListeners();
  }
}
