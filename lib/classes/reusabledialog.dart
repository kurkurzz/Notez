import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> deleteDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[100],
          title: Text(title,
          ),
          content: Text(body,
          ),
          actions: <Widget>[
            FlatButton(
                color: Colors.white ,
                onPressed: () => Navigator.of(context).pop(DialogAction.abort),
                child: Text('Cancel',
                  style: TextStyle(color: Colors.black),
                )),
            FlatButton(
                color: Colors.red ,
                onPressed: () => Navigator.of(context).pop(DialogAction.yes),
                child: Text('Delete'))
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}