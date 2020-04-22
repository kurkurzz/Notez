import 'package:flutter/material.dart';
import 'package:notez/classes/database.dart';
import 'package:notez/classes/reusabledialog.dart';
import 'package:notez/pages/note_type.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:share/share.dart';


//Star colour at note_list
class BlinkStar extends StatefulWidget {
  bool fav;
  Map map;
  BlinkStar(this.fav,this.map);

  @override
  _BlinkStarState createState() => _BlinkStarState();
}

class _BlinkStarState extends State<BlinkStar> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
          widget.fav ? Icons.star : Icons.star_border,
          color: widget.fav ? Color.fromRGBO(255, 241, 108, 1) : Colors.blueGrey[300]
      ),
      onPressed: () {
        if(widget.fav){
          DBHelper.updateNote({
            'id' : widget.map['id'],
            'fav' : 0
          }
          );}
        else {
          DBHelper.updateNote({
            'id' : widget.map['id'],
            'fav' : 1
          });
        }
        setState(() {
          widget.fav = !widget.fav;
        });
        //    DBHelper.deleteNote(notes[index]['id']);
      },
    );
  }
}

//Multiple FAB in note_type
class SpeedButton extends StatefulWidget {

  Map map;
  EditMode editmode;
  String controller;
  SpeedButton({this.map,this.editmode,this.controller});
  @override
  _SpeedButtonState createState() => _SpeedButtonState();
}

class _SpeedButtonState extends State<SpeedButton> {


  @override
  Widget build(BuildContext context) {
   // Fav.buttonfavaddonly = Fav.fav;
    return SpeedDial(
      elevation: 3,
   //   closeManually: true,
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
      animatedIcon: AnimatedIcons.menu_close,
      children:[
        SpeedDialChild(
          elevation: 3,
          child: Icon(
            Icons.star,
          ),
          backgroundColor: Fav.fav? Colors.yellow : Colors.grey,
          onTap: () {
            setState(() {
              Fav.fav = !Fav.fav;
            });
            if(widget.editmode==EditMode.Editing){
              DBHelper.updateNote({
                'id' : widget.map['id'],
                'fav' : Fav.favint()
              }
              );
            }else{
              Fav.buttonfavaddonly = Fav.fav;
              print(Fav.buttonfavaddonly);
            }
          }
        ),
        SpeedDialChild(
            elevation: 3,
            backgroundColor: Colors.blueAccent,
            child: Icon(
              Icons.share,
            ),
            onTap: () {
              setState(() {
                share(context, widget.controller);
              });
            }
        ),
        SpeedDialChild(
            elevation: 3,
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            onTap: () async {
              if (widget.editmode == EditMode.Editing) {
                final action = await Dialogs.deleteDialog(context, 'Warning!',
                    "The note cannot be retrieved once it's deleted.");
                setState(() {
                  if (action == DialogAction.yes) {
                    if (widget.editmode == EditMode.Editing) {
                      DBHelper.deleteNote(widget.map['id']);
                    }
                    Navigator.pop(context);
                  }else{
                  }
                });
              }else{
                if(SaveAdd.save) {
                  int id = await DBHelper.getLastRowID();
                  DBHelper.deleteNote(id);
                }
                Navigator.pop(context);
              }
            }
         ),

      ] ,
    );
  }

  void share(BuildContext context, String text){
    Share.share(text);
  }
}


class Fav{
  static bool fav;
  static bool buttonfavaddonly;

  static int favint(){
    if(fav){
      return 1;
  }
    else{
      return 0;
    }
}

  static int favintfavonly(){
    if(buttonfavaddonly){
      return 1;
    }
    else{
      return 0;
    }
  }
}

class Passing{
  static EditMode editmode;
  static Map map;
}

class Ftext{
  static String text;
}

class SaveAdd{
  static bool save;
}








