import 'package:app_five_habit_trackerr_offline/database/habit_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  void createNewHabit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
