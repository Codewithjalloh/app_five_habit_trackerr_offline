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
}
