// given a habit list of completion days
// is the habit completed today

import '../models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completeDays) {
  final today = DateTime.now();
  return completeDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// prepared heap map dataset
Map<DateTime, int> preHeatMapDatasert(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completeDays) {
      // normalise data to avoid the time mismatch
      final normalisedDate = DateTime(date.year, date.month, date.day);

      // if the date already exists in the dataset, increment its count
      if (dataset.containsKey(normalisedDate)) {
        dataset[normalisedDate] = dataset[normalisedDate]! + 1;
      } else {
        // else initialise it with a count of 1
        dataset[normalisedDate] = 1;
      }
    }
  }
  return dataset;
}
