

// Habit Model Class
class Habit {
  final int? id;
  final String name;
  final String? description;
  final String frequency;
  final int? isDone;

  Habit({
    this.id,
    required this.name,
    this.description,
    required this.frequency,
    required this.isDone
  });

  // Convert Habit to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency,
      'isDone':isDone,
    };
  }

  // Create Habit from database Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      frequency: map['frequency'],
      isDone: map['isDone']
    );
  }
}