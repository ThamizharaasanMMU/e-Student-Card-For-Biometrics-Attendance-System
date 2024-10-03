import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

class DatabaseHelper {

  late MySqlConnection _connection;

  //TODO mySQL initialization
  Future<void> openConnection() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: '192.168.43.169', // emulator : 10.0.2.2
      port: 3306,
      user: 'root',
      db: 'biometric_db',
    ));
  }


  // TODO insertData
  Future<void> insertData(String name, String embedding) async {
    await openConnection();
    try {
      await _connection.query(
        'INSERT INTO biometric_table (uid, embedding) VALUES (?, ?)',
        [name, embedding],
      );
    } catch (e) {
      print('Error inserting data: $e');
    }
  }


  // TODO All of the rows are returned as a list of ResultRow, where each map is
  // TODO a key-value list of columns.
  Future<List<ResultRow>> queryAllRow() async {
    try {
      Results results = await _connection.query(
          'SELECT * FROM biometric_table');
      return results.toList();
    } finally {
      await _connection.close();
    }
  }
}