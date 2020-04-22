import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper{
  static Database db;
  static bool firstime;
  
  static open() async{
    print('create new db');
    db = await openDatabase(join(await getDatabasesPath(),'note.db'),
      version: 1,
      onCreate: (Database db, int version) async{
        db.execute('''
        create table Notes(
        id integer primary key autoincrement,
        text text not null,
        time text not null,
        timefrom int not null,
        fav int
        );
        '''
        );
      }
    );
    if(DBHelper.firstime) {
      DateTime timenow = DateTime.now();
      String formatteddate = DateFormat('dd MMM yyyy, HH:mm').format(timenow);
      await DBHelper.insertNote({
        'text': '''Message from developer.
      \nThis application is completely free to use with no ads. Feel free to give any comments or feedback in Google Play's review section.
      \nMy twitter is always open to anyone who would like to reach out @apezzz_z .
      \nThank you!
      \n-apez
      \nbeautiful icon designed by @aryfadhly 
      ''',
        'time': formatteddate,
        'timefrom': DateTime
            .now()
            .millisecondsSinceEpoch,
        'fav': 0
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getNoteList() async {

    if(db == null) {
      await open();
    }
    return await db.rawQuery('SELECT * FROM Notes ORDER BY fav DESC, timefrom DESC;');
  }

  static Future<Map<String, dynamic>> getNote(int id) async {
    var map = await db.query('Notes', where: 'id = ?', whereArgs: [id]);
    print(map);
    return map[0];
  }

  static Future insertNote(Map<String, dynamic> map) async {
    print('Insert note.');
    await db.insert('Notes', map);
  }

  static Future updateNote(Map<String, dynamic> map) async {
    print('Update note.');
    await db.update('Notes', map, where: 'id = ?', whereArgs: [map['id']]);
  }

  static Future deleteNote(int id) async{
    print('Delete note.');
    await db.delete('Notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> getLastRowID() async {
    var lastInsertRowId = (await db.rawQuery('SELECT last_insert_rowid()')).first.values.first as int;
    print(lastInsertRowId);
    return lastInsertRowId;
  }

}



















