// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:students_app_provider/model/student_mode.dart';

class DatabaseHelper {
  static const _databaseName = 'student.db';
  static const _databaseVersion = 1;
  static const table = 'students';
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnSchool = 'school';
  static const columnAge = 'age';
  static const columnPhone = 'phone';
  static const columnProfileimg = 'profileimg';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnSchool TEXT NOT NULL,
        $columnAge INTEGER NOT NULL,
        $columnPhone INTEGER NOT NULL,
        $columnProfileimg TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertStudent(Student student) async {
    try {
      final db = await database;
      int id = await db.insert(table, {
        columnName: student.name,
        columnAge: student.age,
        columnSchool: student.school,
        columnPhone: student.phone,
        columnProfileimg: student.profileimg,
      });
      print("Student inserted successfully with id: $id");
          return id;
    } catch (e) {
      print("Error inserting student: $e");
      return -1; // or any other error code you prefer
    }
  }

  Future<List<Student>> getStudents() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(table);

      print("Fetched ${maps.length} students from the database");

      List<Student> students = List.generate(
        maps.length,
        (index) => Student(
          id: maps[index][columnId],
          name: maps[index][columnName],
          school: maps[index][columnSchool],
          age: maps[index][columnAge],
          phone: maps[index][columnPhone],
          profileimg: maps[index][columnProfileimg],
        ),
      );

      print("Generated list of students:");
      for (var student in students) {
        print(student);
      }

      return students;
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId=?',
      whereArgs: [id],
    );
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      table,
      {
        columnName: student.name,
        columnAge: student.age,
        columnSchool: student.school,
        columnPhone: student.phone,
        columnProfileimg: student.profileimg,
      },
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }
}
