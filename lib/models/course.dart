import 'dart:convert';

Course courseFromJson(String str) => Course.fromJson(json.decode(str));

String courseToJson(Course data) => json.encode(data.toJson());

class Course {
  Course({
    required this.code,
    required this.course,
  });

  int code;
  List<CourseElement> course;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        code: json["code"],
        course: List<CourseElement>.from(
            json["course"].map((x) => CourseElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "course": List<dynamic>.from(course.map((x) => x.toJson())),
      };
}

class CourseElement {
  CourseElement({
    required this.slug,
    required this.name,
    required this.description,
    required this.shortVideo,
    required this.color,
    required this.icon,
    required this.lastUpdated,
    required this.sections,
  });
  String slug;
  String name;
  String description;
  String shortVideo;
  String color;
  String icon;
  DateTime lastUpdated;
  List<Section> sections;

  factory CourseElement.fromJson(Map<String, dynamic> json) => CourseElement(
        slug: json["slug"],
        name: json["name"],
        description: json["description"],
        shortVideo: json["short_video"],
        color: json["color"],
        icon: json["icon"],
        lastUpdated: DateTime.parse(json["last_updated"]),
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "name": name,
        "description": description,
        "short_video": shortVideo,
        "color": color,
        "icon": icon,
        "last_updated": lastUpdated.toIso8601String(),
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
      };
}

class Section {
  Section({
    required this.section,
    required this.level,
  });

  String section;
  String level;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        section: json["section"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "section": section,
        "level": level,
      };
}
