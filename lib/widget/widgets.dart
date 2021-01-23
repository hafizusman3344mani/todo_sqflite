import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String description;
  TaskCardWidget({this.title, this.description});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'Unnamed Task',
            style: TextStyle(
                color: Color(0xFF211551),
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              description ?? 'No description added.',
              style: TextStyle(
                  fontSize: 14, color: Color(0xFF868290), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String todo;
  final String img;
  final bool isDone;
  TodoWidget({this.todo, this.img, this.isDone = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1/20,
            height: MediaQuery.of(context).size.height * 1/42,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7240FE) : null,
              borderRadius: BorderRadius.circular(6),
              border: isDone
                  ? null
                  : Border.all(
                      color: Color(0xFF868290),
                      width: 1.5,
                    ),
            ),
            child: isDone
                ? Image(
                    image: AssetImage(img ?? 'assets/images/check_icon.png'),
                  )
                : Text(''),
          ),
          Flexible(
            child: Text(
              todo ?? 'Unnamed Task',
              style: TextStyle(
                  color: isDone ? Color(0xFF211551) : Color(0xFF868290),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
