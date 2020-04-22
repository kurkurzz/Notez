import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notez/classes/database.dart';
import 'package:notez/classes/PassArguments.dart';
import 'package:notez/widget_list.dart';

enum EditMode{
  Editing,
  Adding
}

class Note_type extends StatefulWidget {
  @override
  _Note_typeState createState() => _Note_typeState();
}

class _Note_typeState extends State<Note_type> with WidgetsBindingObserver{

  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    if(Passing.editmode==EditMode.Editing){
      textController.text = Passing.map['text'];
    }
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String persist;
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        persist = textController.text;
        print('Paused');
        break;
      case AppLifecycleState.resumed:
        textController.text = persist;
        print('Resumed');
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.detached:
        print('detached');
        break;

    }
  }

  bool savebutt = false;
  @ override
  Widget build(BuildContext context) {

    Passing.map = null;
    Passing.editmode = null;

    var blankFocusNode = new FocusNode();

//    List<Map<String,dynamic>> _notes = NoteInheritedWidget.of(context).notes;
    DateTime timenow = DateTime.now();
    String formatteddate = DateFormat('dd MMM yyyy, HH:mm').format(timenow);
    final PassArguments args = ModalRoute.of(context).settings.arguments;
    if(args.editmode == EditMode.Editing){
      Fav.fav = args.map['fav'] == 1;
    }else{

    }

    return WillPopScope(
      onWillPop: () => backbutton(args.editmode, args.map),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(236, 224, 225, 1),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:  () => backbutton(args.editmode, args.map),
              ),
          title: Text(
            args.editmode==EditMode.Editing ? 'Edit Note' : 'Add Note' ),
          actions: savebutt ? <Widget>[
            IconButton(
              onPressed: (){
                SaveAdd.save = true;
                if(EditMode.Adding==args.editmode){
                  DateTime timenow = DateTime.now();
                  String formatteddate = DateFormat('dd MMM yyyy, HH:mm').format(timenow);
                  DBHelper.insertNote({
                    'text' : textController.text,
                    'time' : formatteddate,
                    'timefrom' : DateTime.now().millisecondsSinceEpoch,
                //    'fav' : Fav.favintfavonly()
                  });
                }
                else {
                  DBHelper.updateNote({
                    'id' : args.map['id'],
                    'text' : textController.text,
                    'time' : formatteddate,
                    'timefrom' : DateTime.now().millisecondsSinceEpoch,
                  });
                }
                FocusScope.of(context).requestFocus(blankFocusNode);
                setState(() {
                  savebutt = false;
                });
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
            )

          ] :null

        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 3),
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    EditMode.Adding==args.editmode? formatteddate : args.map['time'],
                    style: TextStyle(
                      color: Colors.black45,
                      fontFamily: 'RobotoMonoRegular'
                    ),
                  ),
                )
              ],
            ),
            TextFormField(
              onTap:(){
                setState(() {
                  savebutt = true;
                });
              },
              controller: textController,
              style: TextStyle(
                fontFamily: 'RobotoMonoRegular',
                fontSize: 15
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 100,
              decoration: InputDecoration(
                fillColor: Colors.brown[200],
              ),
            )
          ],
        ),
        floatingActionButton: SpeedButton(map: args.map, editmode: args.editmode,controller: textController.text  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Future backbutton(EditMode editmode, Map map) async{
      if(editmode == EditMode.Adding) {
        if(SaveAdd.save) {
          print(Fav.favintfavonly());
          int id = await DBHelper.getLastRowID();
          Map maps = await DBHelper.getNote(id);
          String checkspace = maps['text'].replaceAll(new RegExp(r' '), '');
          if (checkspace == '' ) {
            DBHelper.deleteNote(id);
          } else {
            DBHelper.updateNote({
              'id': id,
              'fav': Fav.favintfavonly()
            });
          }
        }
        Fav.buttonfavaddonly = false;
      }
      else{
        Map maps = await DBHelper.getNote(map['id']);
        String checkspace = maps['text'].replaceAll(new RegExp(r' '), '');
        if(checkspace==''){
          DBHelper.deleteNote(maps['id']);
        }
      }
      Navigator.pop(context);
  }
}


