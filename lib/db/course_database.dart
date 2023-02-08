import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/course.dart';
import '../models/lesson.dart';

final String courseElement = 'coursesElement';
final String tablesections = 'sections';
final String lessontable = 'lessons';
final String lesson_contnent_table = 'lessonsContent';

class CourseDatabase {
  static final CourseDatabase instance = CourseDatabase.init();

  static Database? _database;
  CourseDatabase.init();
  Future<Database> get database async {
    // if it's exist return database
    if (_database != null) return _database!;
    // other wise inisialize a database
    _database = await _initDB('course.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // get the default database location
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY ';
    final idTextType = 'TEXT PRIMARY KEY ';
    final textType = 'TEXT NOT NULL';
    final fk_course =
        'FOREIGN KEY (${LessonsElementFields.courseSlug}) REFERENCES $courseElement(${CourseElementFields.slug})';
    final fk_lesson =
        'FOREIGN KEY (${LessonsContentFields.lessonId}) REFERENCES $lessontable(${LessonsElementFields.lesson_id})';

    final textTypeNull = 'TEXT';
    final boolType = 'BOOLEAN NOT NULL';
    final dateType = 'DATE';
    final intType = 'INTEGER NOT NULL';
    final intTypeNull = 'INTEGER';
    print("...createing table.....");
    // CREATEING TABLES
// COURSE TABLE
    await db.execute('''
CREATE TABLE $courseElement (
      ${CourseElementFields.course_id} $idType,
      ${CourseElementFields.name} $textTypeNull,
      ${CourseElementFields.slug} $textTypeNull,
      ${CourseElementFields.description} $textTypeNull,
      ${CourseElementFields.color} $textTypeNull,
      ${CourseElementFields.icon} $textTypeNull,
      ${CourseElementFields.shortVideo} $textTypeNull,
      ${CourseElementFields.lastUpdated} $textTypeNull,
      ${CourseElementFields.eneabled} $boolType,
      ${CourseElementFields.seenCounter} $intTypeNull,
      ${CourseElementFields.isLastSeen} $intTypeNull
       )
    ''');

// SECTION TABLE
//     await db.execute('''
// CREATE TABLE $tablesections (
//       ${SectionFields.sec_id} $idType,
//       ${SectionFields.course_id} $textTypeNull,
//       ${SectionFields.sections} $textTypeNull,
//       ${SectionFields.level} $textTypeNull,

//     )
//     ''');

// LESSON TABLE
    await db.execute('''
CREATE TABLE $lessontable (
      ${LessonsElementFields.lesson_id} $intType,
      ${LessonsElementFields.slug} $textTypeNull,
      ${LessonsElementFields.title} $textTypeNull,
      ${LessonsElementFields.section} $textTypeNull,
      ${LessonsElementFields.courseSlug} $textTypeNull,
      ${LessonsElementFields.publishedDate} $textTypeNull,
      $fk_course
    )
    ''');
    await db.execute('''
CREATE TABLE $lesson_contnent_table (
      ${LessonsContentFields.id} $idType,
      ${LessonsContentFields.lessonId} $textTypeNull,
      ${LessonsContentFields.content} $textTypeNull,
      $fk_lesson
    )
    ''');
  }

  // Future<Section> createSection(Section courseSec, String courseid) async {
  //   final db = await instance.database;
  //   final json = courseSec.toJson();
  //   final columns =
  //       '${SectionFields.sec_id},${SectionFields.course_id},${SectionFields.sections},${SectionFields.level}';
  //   final values =
  //       '${json[SectionFields.sec_id]},$courseid,${SectionFields.sections},${json[SectionFields.level]}';
  //   final id = await db.rawInsert(
  //       'INSERT INTO $tablesections ($columns) VALUES(?,?,?,?)', [values]);
  //   return courseSec.copy(sec_id: id.toString());
  // }

  Future<CourseElement> createCourses(CourseElement courseElem) async {
    final db = await instance.database;

    final id = await db.insert(courseElement, courseElem.toJson());
    //for (var i = 0; i < courseElem.sections!.length; i++) {
    //   await CourseDatabase.instance
    //       .createSection(courseElem.sections![i], id.toString());
    //}

    return courseElem.copy(course_id: id);
  }

  Future<LessonElement> createLessons(
      LessonElement lessonElement, int courseId) async {
    final db = await instance.database;
    final json = lessonElement.toJson();
    await db.insert(lessontable, lessonElement.toJson());
    for (var i = 0; i < lessonElement.content.length; i++) {
      await CourseDatabase.instance.createLessonsContent(
          lessonElement.content[i],
          json[LessonsElementFields.lesson_id].toString());
    }
    return lessonElement;
  }

  Future<LessonContent> createLessonsContent(
      String content, String lessonid) async {
    final db = await instance.database;
    LessonContent lescon = LessonContent(lessonId: lessonid, content: content);
    final id = await db.insert(lesson_contnent_table, lescon.toJson());

    return lescon.copy(id: id);
  }

// READ SINGLE COURSE DATA'
  Future<Course> readCourse(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      courseElement,
      columns: CourseElementFields.values,
      where: '${CourseElementFields.course_id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Course.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<LessonElement>> readLesson(String courseSlug) async {
    final db = await instance.database;
    final result = await db.query(
      lessontable,
      columns: LessonsElementFields.values,
      where: '${LessonsElementFields.courseSlug} = ?',
      whereArgs: [courseSlug],
    );
    if (result.isNotEmpty) {
      return result.map((json) => LessonElement.fromJson(json)).toList();
    }
    if (result.isEmpty) {
      return [];
    } else {
      return [];
    }
  }

  Future<List<CourseElement>> readAllCourse() async {
    final db = await instance.database;
    final orderby = '${CourseElementFields.isLastSeen} ASC';
    final result = await db.query(courseElement, orderBy: orderby);
    return result.map((json) => CourseElement.fromJson(json)).toList();
  }
// Future<List<Section>> readAllSection() async {
//     final db = await instance.database;
//     final result = await db.query(tablesections);
//     return result.map((json) => Section.fromJson(json)).toList();
//   }

  Future<List<LessonElement>> readAllLesson() async {
    final db = await instance.database;

    final result = await db.query(lessontable);

    return result.map((json) => LessonElement.fromJson(json)).toList();
  }

  Future<List<LessonContent>> readLessonContets(int lessonId) async {
    final db = await instance.database;
    final result = await db.query(
      lesson_contnent_table,
      columns: LessonsContentFields.lessonsvalue,
      where: '${LessonsContentFields.lessonId} = ?',
      whereArgs: [lessonId],
    );
    if (result.isNotEmpty) {
      return result.map((json) => LessonContent.fromJson(json)).toList();
    }
    if (result.isEmpty) {
      return [];
    } else {
      return [];
    }
  }

  Future<List<LessonContent>> readAllLessonContent() async {
    final db = await instance.database;

    final result = await db.query(lesson_contnent_table);

    return result.map((json) => LessonContent.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
