import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/views/tasks/task_view.dart';

import '../../../models/task.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  // ignore: library_private_types_in_public_api
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubtitle = TextEditingController();
  @override
  void initState() {
    super.initState();
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubtitle.text = widget.task.subtitle;
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubtitle.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        ///Navigate to Task View to see Task Details
        Navigator.push(context,CupertinoPageRoute(builder: (ctx)=>TaskView(
            titleTaskController: textEditingControllerForTitle,
            descriptionTaskController:textEditingControllerForSubtitle,
            task: widget.task),), );
      },
      child: AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          decoration: BoxDecoration(
              color:widget.task.isCompleted?
              Color.fromARGB(154, 119, 144, 229):Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: Offset(0,4),
                blurRadius: 10,
              )]
          ),
          duration: Duration(milliseconds: 600),
          child: ListTile(

            ///Check Icon
            leading: GestureDetector(
              onTap: (){
                //Check or Uncheck Task
                widget.task.isCompleted= !widget.task.isCompleted;
                widget.task.save();
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                decoration: BoxDecoration(
                    color:widget.task.isCompleted?
                    AppColors.primaryColor:Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey,width: .8)
                ),
                child: Icon(Icons.check,color: Colors.white,),
              ),
            ),

            ///Task Title
            title: Padding(
              padding: EdgeInsets.only(bottom:5.0,top: 3),
              child: Text(textEditingControllerForTitle.text,
                style: TextStyle(
                  color: widget.task.isCompleted?AppColors.primaryColor:Colors.black,
                  fontWeight: FontWeight.w500,
                  decoration:widget.task.isCompleted?
                  TextDecoration.lineThrough:null,
                ),
              ),
            ),


            subtitle:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ///Task Description
                Text(textEditingControllerForSubtitle.text,
                  style: TextStyle(
                      color:widget.task.isCompleted?AppColors.primaryColor:Colors.black,
                      fontWeight: FontWeight.w300,
                    decoration: widget.task.isCompleted?TextDecoration.lineThrough:null,
                  ),
                ),


                ///Date and Time of Task
                Align(alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10,top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat("hh:mm a").format(widget.task.createdAtTime),
                          style: TextStyle(
                              fontSize: 14,
                              color:widget.task.isCompleted?Colors.white:
                              Colors.grey),),
                        Text(DateFormat.yMMMEd().format(widget.task.createdAtDate),
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.task.isCompleted?Colors.white:
                              Colors.grey),),
                      ],
                    ),
                  ),
                )
              ],
            ) ,
          )),
    );
  }
}