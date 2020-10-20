import 'package:flutter/material.dart';
import 'package:notez/pages/note_type.dart';
import 'package:notez/widget_list.dart';
import '../classes/database.dart';
import 'package:notez/classes/PassArguments.dart';
import 'package:notez/classes/reusabledialog.dart';

class Note_list extends StatefulWidget {
  @override
  _Note_listState createState() => _Note_listState();
}

class _Note_listState extends State<Note_list> {
  @override
  Widget build(BuildContext context) {
    SaveAdd.save = false;
    // List<Map<String,dynamic>> _notes = NoteInheritedWidget.of(context).notes;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Notez',
            style: TextStyle(fontFamily: 'Sarina'),
          ),
        ),
        backgroundColor: Color.fromRGBO(236, 224, 225, 1), // Colors.brown[100],
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: FutureBuilder(
              future: DBHelper.getNoteList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final notes = snapshot.data;
                  return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            indent: 10,
                            endIndent: 10,
                            thickness: 1,
                            height: 0,
                            color: Colors.blueGrey[300],
                          ),
                      itemCount: notes == null ? 0 : notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          color: Color.fromRGBO(
                              236, 224, 225, 1), // Colors.brown[100],
                          elevation: 0.0,
                          child: Dismissible(
                            key: Key(notes[index]['text']),
                            background: Container(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                              color: Color.fromRGBO(232, 97, 110, 1),
                            ),
                            secondaryBackground: Container(
                              color: Color.fromRGBO(236, 224, 225, 1),
                            ),
                            confirmDismiss: (direction) async {
                              Map map = notes[index];
                              if (direction == DismissDirection.startToEnd) {
                                final action = await Dialogs.deleteDialog(
                                    context,
                                    'Warning!',
                                    "The note cannot be retrieved once it's deleted.");
                                if (action == DialogAction.yes) {
                                  setState(() {
                                    DBHelper.deleteNote(notes[index]['id']);
                                  });
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Deleted succesfully.'),
                                    duration: Duration(seconds: 2),
                                    action: SnackBarAction(
                                        label: 'undo',
                                        textColor: Colors.brown[200],
                                        onPressed: () {
                                          setState(() {
                                            DBHelper.insertNote(map);
                                          });
                                        }),
                                  ));
                                }
                              }
                              return;
                            },
                            child: ListTile(
                                onTap: () async {
                                  final map = await DBHelper.getNote(
                                      notes[index]['id']);
                                  Passing.map = map;
                                  Passing.editmode = EditMode.Editing;
                                  Navigator.pushNamed(
                                    context,
                                    '/edit',
                                    arguments: PassArguments(
                                        editmode: EditMode.Editing, map: map),
                                  );
                                },
                                title: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  text: TextSpan(
                                    text: notes[index]['text'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'RobotoMonoMedium',
                                      color: Colors.black,
                                      //   fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  notes[index]['time'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'RobotoMonoRegular',
                                  ),
                                ),
                                trailing: BlinkStar(
                                    notes[index]['fav'] == 1, notes[index])),
                          ),
                        );
                      });
                }
                return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.blueGrey));
              }),
        ),
        floatingActionButton: Opacity(
          opacity: 0.8,
          child: FloatingActionButton(
            onPressed: () {
              Fav.fav = false;
              Fav.buttonfavaddonly = Fav.fav;
              Navigator.pushReplacementNamed(context, '/edit',
                  arguments: PassArguments(editmode: EditMode.Adding));
            },
            elevation: 3,
            backgroundColor: Colors.blueGrey[600],
            child: Icon(Icons.add),
          ),
        ));
  }
}
