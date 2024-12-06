import 'package:flutter/material.dart';
import 'package:habit_tracker/add_habit_page.dart/addhabit_page.dart';
import 'package:habit_tracker/add_habit_page.dart/local/models.dart';
import 'package:habit_tracker/helper_classes/db_helper.dart';
import 'package:habit_tracker/homepage/widgets/habit_list_widget.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List to store habits
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    // Fetch habits when the page initializes
    _fetchHabits();
  }

  // Method to fetch habits from the database
  Future<void> _fetchHabits() async {
    try {
      final habits = await DatabaseHelper.instance.getAllHabits();
      setState(() {
        _habits = habits;
      });
    } catch (e) {
      // Handle any errors in fetching habits
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load habits: $e')),
      );
    }
  }

  Future<void> _updateHabits(Habit habit) async {
  try {
    await DatabaseHelper.instance.updateHabit(habit);
    _fetchHabits(); // Refresh the list after the update
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update habit: $e')),
    );
  }
}


  // Method to delete a habit
  Future<void> _deleteHabit(int habitId) async {
    try {
      await DatabaseHelper.instance.deleteHabit(habitId);
      // Refresh the list after deletion
      _fetchHabits();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete habit: $e')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  // Filter habits to show only those that are not done
  final activeHabits = _habits.where((habit) => habit.isDone == 0).toList();

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _fetchHabits,
        ),
      ],
    ),
    drawer: Drawer(
      surfaceTintColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red.shade900,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.bar_chart,
              color: Colors.deepPurple,
            ),
            title: const Text('Analytics'),
            onTap: () {
              // Add navigation logic here if needed
            },
          ),
        ],
      ),
    ),
    body: activeHabits.isEmpty
        ? Center(
            child: Text(
              'No active habits yet. Add a new habit!',
              style: TextStyle(fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: activeHabits.length,
            itemBuilder: (BuildContext context, int index) {
              final habit = activeHabits[index];
              return Dismissible(
                key: Key(habit.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  // Optional: Uncomment to delete the habit permanently
                  // _deleteHabit(habit.id!);
                },
                child: HabitListWidget(
                  habitName: habit.name,
                  description: habit.description ?? 'No description',
                  timestamp: habit.frequency,
                  color: Colors.black12,
                  isDone: habit.isDone ?? 0,
                  onParkingNumberSelected: (updatedHabit) => _updateHabits(updatedHabit),
                ),
              );
            },
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddhabitPage()),
        );
        _fetchHabits(); // Refresh habits after adding a new one
      },
      tooltip: 'Add Habit',
      child: const Icon(Icons.add),
    ),
  );
}
}