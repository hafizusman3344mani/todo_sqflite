import 'package:flutter/material.dart';
import 'package:what_todo/db/database_helper.dart';
import 'package:what_todo/model/task.dart';
import 'package:what_todo/model/todo.dart';
import 'package:what_todo/widget/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _todoEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  DatabaseHelper _dataBaseHelper = DatabaseHelper();
  int _taskId = 0;
  int _todoId = 0;
  String _taskTitle = '';
  String _taskDescription = '';

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;
  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {

      _contentVisible = true;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;

    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: _titleFocus,
          controller: _textEditingController..text = _taskTitle,
          onSubmitted: (value) async {

            //_textEditingController.clear();
            // Navigator.of(context).pop();
            if (value != '') {
              if (widget.task == null) {
                Task newTask = Task(title: value);
                _taskId = await _dataBaseHelper.insertTask(newTask);
                setState(() {
                  _contentVisible = true;
                  _taskTitle = value;
                });
              }
              else{
                await _dataBaseHelper.updateTask(_taskId, value);
              }
            }
            _descriptionFocus.requestFocus();
          },
          cursorColor: Color(0xFF211551),
          decoration: InputDecoration(
            hintText: 'Enter task title here..',
            border: InputBorder.none,
          ),
          style: TextStyle(
              color: Color(0xFF211551),
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image(
              image: AssetImage('assets/images/back_arrow_icon.png'),
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: _contentVisible,
                  child: TextField(
                    controller: _descriptionEditingController..text = _taskDescription,
                    focusNode: _descriptionFocus,
                    cursorColor: Color(0xFF211551),
                    decoration: InputDecoration(
                        hintText: 'Enter the description for the task...',
                        border: InputBorder.none),
                    onSubmitted: (value) async{
                      if(value != ''){
                        if(_taskId != 0){
                          await _dataBaseHelper.updateDescription(_taskId, value);
                          _taskDescription =value;
                        }
                      }
                      _todoFocus.requestFocus();
                    },
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder(
                      initialData: [],
                      future: _dataBaseHelper.getTodo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: ()async {
                                    if(snapshot.data[index].isDone == 0){
                                     await _dataBaseHelper.updateTodoDone(snapshot.data[index].id, 1);
                                    }
                                    else{
                                      await _dataBaseHelper.updateTodoDone(snapshot.data[index].id, 0);
                                    }
                                    setState(() {
                                      _todoId = snapshot.data[index].isDone;
                                    });
                                    _todoFocus.requestFocus();
                                  },
                                  child: TodoWidget(
                                    todo: snapshot.data[index].title,
                                    isDone: snapshot.data[index].isDone == 0
                                        ? false
                                        : true,
                                  ),
                                );
                              }),
                        );
                      }),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1 / 20,
                          height: MediaQuery.of(context).size.height * 1 / 38,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Color(0xFF868290),
                              width: 1.5,
                            ),
                          ),
                          child: Image(
                            image: AssetImage('assets/images/check_icon.png'),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _todoEditingController,
                            focusNode: _todoFocus,
                            onSubmitted: (value) async {
                              if (value != '') {
                                _todoEditingController.clear();
                                if (_taskId != 0) {
                                  Todo newTodo = Todo(
                                      title: value,
                                      taskId: _taskId,
                                      isDone: 0);
                                  await _dataBaseHelper.insertTodo(newTodo);
                                  _todoFocus.requestFocus();
                                  setState(() {});
                                }
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'Enter todo item...',
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                bottom: 20,
                right: 10,
                child: GestureDetector(
                  onTap: () async {
                    if(_taskId != 0){
                        _dataBaseHelper.deleteTodo(1);
                        setState(() {});
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1 / 8,
                    height: MediaQuery.of(context).size.width * 1 / 8,
                    child: Image(
                      image: AssetImage('assets/images/delete_icon.png'),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFFFE3572),
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
