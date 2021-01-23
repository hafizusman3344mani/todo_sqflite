import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:what_todo/db/database_helper.dart';
import 'package:what_todo/screens/task_page.dart';

import '../widget/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 32, top: 32),
                      child:
                          Image(image: AssetImage('assets/images/logo.png'))),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _databaseHelper.getTask(),
                      builder: (context, snapshot) {
                        return ScrollConfiguration(
                          behavior: NoGlowBehavior(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onLongPress: () {
                                  show(snapshot.data[index].id,context);
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskPage(
                                                task: snapshot.data[index],
                                              ))).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  description: snapshot.data[index].description,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (BuildContext context) => TaskPage(
                                  task: null,
                                )))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1 / 8,
                    height: MediaQuery.of(context).size.width * 1 / 8,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FD8)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                        ),
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  show(int id,BuildContext context) async {
    (!Platform.isIOS)
        ? showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(''),
              content: Text('Do you want to delete ?'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      DatabaseHelper _dataBaseHelper = DatabaseHelper();
                      await _dataBaseHelper.deleteTask(id).then((value) {
                        setState(() {

                        });
                        Navigator.of(context).pop();
                      });



                    }),
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          )
        : showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(''),
              content: Text("Do you want to delete ?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Yes'),
                  onPressed: () async {
                    DatabaseHelper _dataBaseHelper = DatabaseHelper();
                    await _dataBaseHelper.deleteTask(id).then((value) {
                      Navigator.of(context).pop();
                      setState(() {});
                    });


                  },
                ),
                CupertinoDialogAction(
                  child: Text('No'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
  }
}
