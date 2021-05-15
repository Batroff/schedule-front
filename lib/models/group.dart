import 'dart:convert';
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

    if (daysFromJson == null) {
      return null;
    }

    Map<String, List<Lesson>> days = new Map();
    daysFromJson.forEach((dayName, lessons) {
      days[dayName] = new List<Lesson>.from(lessons.map((l) => Lesson.fromJson(l)));
    });

    return Group(name, subGroup, days);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'subgroup': subGroup,
    'days': days,
  };

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

  bool equals(Group someGroup){
    if (someGroup.name == this.name){
      if (someGroup.subGroup == this.subGroup){
        for(var item in this.days.entries){
          if(someGroup.days[item.key].length == this.days[item.key].length){
            for(var i = 0; i < this.days[item.key].length; i++){
              if (someGroup.days[item.key][i].equals(this.days[item.key][i])){

              } else return false;
            }
          } else return false;
        }
      } else return false;
    } else return false;
    return true;
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

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'typeOfLesson': typeOfLesson,
    'teacherName': teacherName,
    'cabinet': cabinet,
    'numberLesson': numberLesson,
    'occurrenceLesson': occurrenceLesson,
  };

  void showInfo() {
    print("\t\tsubject: ${this.subject}, \n"
          "\t\ttypeOfLesson: ${this.typeOfLesson}, \n"
          "\t\tteacherName: ${this.teacherName}, \n"
          "\t\tcabinet: ${this.cabinet}, \n"
          "\t\tnumberLesson: ${this.numberLesson}, \n"
          "\t\toccurrenceLesson: ${this.occurrenceLesson}."
    );
  }

  bool equals(Lesson someLesson){
    if (this.subject == someLesson.subject){
      if (this.typeOfLesson == someLesson.typeOfLesson){
        if (this.numberLesson == someLesson.numberLesson){
          if (this.cabinet == someLesson.cabinet){
            if (this.teacherName == someLesson.teacherName){
              if (this.occurrenceLesson.length == someLesson.occurrenceLesson.length){
                for (var i=0; i<this.occurrenceLesson.length; i++){
                  if (this.occurrenceLesson[i] == someLesson.occurrenceLesson[i]){

                  } else return false;
                }
              } else return false;
            } else return false;
          } else return false;
        } else return false;
      } else return false;
    } else return false;
    return true;
  }
}
