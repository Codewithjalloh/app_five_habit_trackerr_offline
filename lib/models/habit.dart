import 'package:isar/isar.dart';

// Add dependencies
// flutter pub add isar isar_flutter_libs path_provider
// flutter pub add -d isar_generator build_runner

// run cmd to generate file: flutter pub run build_runner build
part "habit.g.dart";

@collection
class Habit {
  // habit id
  Id id = Isar.autoIncrement;

  // habit name
  late String name;

  // complete days
  List<DateTime> completeDays = [
    // DateTime(year, month, day),
    // DateTime(2024, 1, 1),
    // DateTime(2024, 1, 2),
  ];
}
