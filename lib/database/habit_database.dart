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

// UPDATE - change habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is complete -> add the current date to the completeDays list
        if (isCompleted && !habit.completeDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();

          // add the current date if it's not already in the list
          habit.completeDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        } else {
          // if habit is NOT completed -> remove the current date from the list
          habit.completeDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        // save the updated habit back to db
        await isar.habits.put(habit);
      });
    }
    // re-deo from db
    readHabits();
  }

  // UPDATE - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update habit name
    if (habit != null) {
      // update name
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    // re-read from db
    readHabits();
  }

  // DELETE - Delete habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    // re-read from db
    readHabits();
  }
}
