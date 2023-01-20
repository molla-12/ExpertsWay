import 'dart:convert';

import 'package:learncoding/models/course.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// import '../models/course_table.dart';
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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY ';
    final textType = 'TEXT NOT NULL';
    final fk =
        'FOREIGN KEY (${CourseElementFields.id}) REFERENCES $courseElement(${CourseElementFields.id})';
    final textTypeNull = 'TEXT';
    final boolType = 'BOOLEAN NOT NULL';
    final dateType = 'DATE';
    final intType = 'INTEGER NOT NULL';
    final intTypeNull = 'INTEGER';
    print("...createing table.....");

//     await db.execute('''
// CREATE TABLE $tableCourses (
//       ${CourseFields.code} $intType
//     )
//     ''');

    await db.execute('''
CREATE TABLE $courseElement (
      ${CourseElementFields.id} $idType,
      ${CourseElementFields.name} $textTypeNull,
      ${CourseElementFields.slug} $textTypeNull,
      ${CourseElementFields.description} $textTypeNull,
      ${CourseElementFields.color} $textTypeNull,
      ${CourseElementFields.icon} $textTypeNull,
      ${CourseElementFields.sections} $textTypeNull,
      ${CourseElementFields.shortVideo} $textTypeNull,
      ${CourseElementFields.lastUpdated} $textTypeNull,
      ${CourseElementFields.prerequests} $textTypeNull,
      ${CourseElementFields.eneabled} $boolType
   
    )
    ''');
    await db.execute('''
CREATE TABLE $tablesections (
      ${SectionFields.sec_id} $intTypeNull,
      ${SectionFields.course_id} $textTypeNull,
      ${SectionFields.sections} $textTypeNull,
      ${SectionFields.level} $textTypeNull,
      $fk
    )
    ''');
  }

  Future<Section> createSection(Section courseSec, String courseid) async {
    final db = await instance.database;

    final json = courseSec.toJson();
    final columns =
        '${SectionFields.sec_id},${SectionFields.course_id},${SectionFields.sections},${SectionFields.level}';
    final values =
        '${json[SectionFields.sec_id]},$courseid,${SectionFields.sections},${json[SectionFields.level]}';

    final id = await db.rawInsert(
        'INSERT INTO $tablesections ($columns) VALUES(?,?,?,?)', [values]);
    return courseSec.copy(sec_id: id.toString());
  }

  Future<CourseElement> create(CourseElement courseElem, int index) async {
    final db = await instance.database;

    final id = await db.insert(courseElement, courseElem.toJson());

    for (var i = 0; i < courseElem.sections!.length; i++) {
      await CourseDatabase.instance
          .createSection(courseElem.sections![i], id.toString());
    }
    return courseElem.copy(id: id);
  }

  Future<Course> readCourse(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      courseElement,
      // tablesections,
      columns: CourseElementFields.values,
      where: '${CourseElementFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Course.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<CourseElement>> readAllCourse() async {
    final db = await instance.database;

    // final orderby = '${CourseElementFields.lastUpdated} ASC';

    final result = await db.query(courseElement);

    return result.map((json) => CourseElement.fromJson(json)).toList();
  }

  Future<List<Section>> readAllSection() async {
    final db = await instance.database;
    final result = await db.query(tablesections);
    return result.map((json) => Section.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
