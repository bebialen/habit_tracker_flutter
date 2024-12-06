import 'package:flutter/material.dart';
import 'package:habit_tracker/add_habit_page.dart/local/models.dart';

class HabitListWidget extends StatefulWidget {
  final String habitName;
  final String description;
  final String timestamp;
  final int isDone;

  //final String phone;
  // final String imageUrl;
  final Color color;
  final Function(Habit)? onParkingNumberSelected; // Accept a callback for Habit
  // Callback function

  const HabitListWidget({
    super.key, // Use 'Key?' instead of 'super.key'
    required this.habitName,
    required this.description,
    required this.timestamp,
    //required this.imageUrl,
    required this.color,
    this.onParkingNumberSelected,
    required this.isDone, // This will track the checkbox state
  });

  @override
  _HabitListWidgetState createState() => _HabitListWidgetState();
}

class _HabitListWidgetState extends State<HabitListWidget> {
  bool isChecked = false;
  bool useParkingNumber = false; // This will track the checkbox state

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isDone == 1 ? false : true,
      child: Card(
        color: Theme.of(context).cardTheme.color,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 8,
                color: widget.color,
              ),
            ),
          ),
          child: ListTile(
            title: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.habitName,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.timestamp,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Checkbox(
              value: isChecked,
              activeColor: Colors.red,
              
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                  if (isChecked) {
                    
                    // Trigger the callback if it's provided
                    if (widget.onParkingNumberSelected != null) {
                      widget.onParkingNumberSelected!(Habit(
                        name: widget.habitName,
                        description: widget.description,
                        frequency: widget.timestamp,
                        isDone: 1,
                      ));

                      print('The value of is Checked is ${isChecked}');
                    print('The value of is Done is ${widget.isDone}');
                    }
                  }
                });
              },
            ),
            tileColor: Colors.white,
            shape: const RoundedRectangleBorder(
                // side: BorderSide(color: Colors.red, width: 1),
                // borderRadius: BorderRadius.circular(8),
                ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          ),
        ),
      ),
    );
  }
}
