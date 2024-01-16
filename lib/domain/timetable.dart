class TimeTable {
  final int id;
  final String subject;
  final String day;
  final String time;

  TimeTable({
    required this.id,
    required this.subject,
    required this.day,
    required this.time,
  });

  TimeTable copyWith({
    int? id,
    String? subject,
    String? day,
    String? time,
  }) {
    return TimeTable(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      day: day ?? this.day,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'day': day,
      'time': time,
    };
  }

  factory TimeTable.fromMap(Map<String, dynamic> map) {
    return TimeTable(
      id: map['id']?.toInt() ?? 0,
      subject: map['subject'] ?? '',
      day: map['day'] ?? '',
      time: map['time'] ?? '',
    );
  }
}
