import 'package:flutter/material.dart';
import 'package:notez/classes/database.dart';
import 'package:notez/pages/note_list.dart';
import 'package:notez/pages/note_type.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver{


  Future<int> getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('nabila');
    if(startupNumber==null){
      return 0;
    }return startupNumber;
  }

  Future<void> incrementStartup() async {
    final prefs = await SharedPreferences.getInstance();

    int lastStartupNumber = await getIntFromSharedPref();
    int currentStartupNumber = ++lastStartupNumber;

    await prefs.setInt('nabila', currentStartupNumber);

    if (currentStartupNumber >= 2) {
      DBHelper.firstime = false;
    } else{
      DBHelper.firstime =true;
    }
  }

  @override
  void initState(){
    super.initState();
    incrementStartup();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Notez',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/edit':
              return PageTransition(
                duration: Duration(milliseconds: 100),
                child: Note_type(),
                type: PageTransitionType.fade,
                settings: settings,
              );
              break;
            default:
              return null;
          }
        },
        initialRoute: '/',
        routes: {
          '/':(context) => Note_list(),
         // '/edit': (context) => note_type(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blueGrey[700]),
          cursorColor: Colors.blueGrey,
          highlightColor: Colors.blueGrey[200],
          splashColor: Colors.blueGrey[200],
          fontFamily: 'NotoSans',
          brightness: Brightness.light,
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.blueGrey[500],
          accentColor: Colors.blueGrey
        ),
      );
  }
}
