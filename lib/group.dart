import 'dart:io';

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

  void showInfo() {
    print("Group name: ${this.name}, subgroup: ${this.subGroup}");
    days.forEach((day, lessons) {
      stdout.write("$day: [\n");
      lessons.forEach((lesson) {
        stdout.write("\tlesson: [\n");
        lesson.showInfo();
        stdout.write("\t],\n");
      });
      stdout.write("], \n");
    });
  }
}

class Lesson {
  String subject;
  String typeOfLesson;
  String teacherName;
  String cabinet;
  int numberLesson;
  List<bool> occurrenceLesson;

  Lesson(this.subject, this.typeOfLesson, this.teacherName, this.cabinet, this.numberLesson, this.occurrenceLesson);

  Lesson.fromJson(Map<String, dynamic> json) :
        subject = json['subject'],
        typeOfLesson = json['typeOfLesson'],
        teacherName = json['teacherName'],
        cabinet = json['cabinet'],
        numberLesson = json['numberLesson'],
        occurrenceLesson = new List<bool>.from(json['occurrenceLesson']);

  void showInfo() {
    print("\t\tsubject: ${this.subject}, \n"
          "\t\ttypeOfLesson: ${this.typeOfLesson}, \n"
          "\t\tteacherName: ${this.teacherName}, \n"
          "\t\tcabinet: ${this.cabinet}, \n"
          "\t\tnumberLesson: ${this.numberLesson}, \n"
          "\t\toccurrenceLesson: ${this.occurrenceLesson}."
    );
  }
}
