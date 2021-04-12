class Group {
  String name;
  int subGroup;
  Map<String, List<Lesson>> days;

  Group(this.name, this.subGroup, this.days);

  factory Group.fromJson(Map<String, dynamic> json) {
    var name = json['name'];
    var subGroup = json['subgroup'];
    var daysFromJson = json['days'];

    Map<String, List<Lesson>> days = new Map();
    daysFromJson.forEach((dayName, lessons) {
      days[dayName] = new List<Lesson>.from(lessons.map((l) => Lesson.fromJson(l)));
    });

    return Group(name, subGroup, days);
  }
}

class Lesson {
  String subject;
  String typeOfLesson;
  String teacherName;
  String cabinet;
  int numberLesson;
  String dayOfWeek;
  List<bool> occurrenceLesson;
  bool exists;
  int subGroup;

  Lesson(this.subject, this.typeOfLesson, this.teacherName, this.cabinet, this.numberLesson, this.dayOfWeek, this.occurrenceLesson, this.exists, this.subGroup);

  Lesson.fromJson(Map<String, dynamic> json) :
        subject = json['subject'],
        typeOfLesson = json['typeOfLesson'],
        teacherName = json['teacherName'],
        cabinet = json['cabinet'],
        numberLesson = json['numberLesson'],
        dayOfWeek = json['dayOfWeek'],
        occurrenceLesson = new List<bool>.from(json['occurrenceLesson']),
        exists = json['exists'],
        subGroup = json['subGroup'];

  void showInfo() {
    print("subject: $subject, "
          "typeOfLesson: $typeOfLesson, "
          "teacherName: $teacherName, "
          "cabinet: $cabinet, "
          "numberLesson: $numberLesson, "
          "dayOfWeek: $dayOfWeek, "
          "occurrenceLesson: $occurrenceLesson, "
          "exists: $exists, "
          "subGroup: $subGroup"
    );
  }
}
