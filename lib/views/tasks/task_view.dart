import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/extensions/space_exs.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/utils/app_str.dart';
import 'package:to_do_app/utils/constants.dart';
import '../../models/task.dart';
import '../home/component/date_time_selection.dart';
import '../home/component/rep_textfield.dart';
import '../home/widgets/task_view_app_bar.dart';


class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  //Show Selected Time as String Format
  String showTime(DateTime? time){
    if(widget.task?.createdAtTime==null){
      if(time==null){
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      }else{
        return DateFormat('hh:mm a').format(time).toString();
      }
      
    }else{
      return DateFormat('hh:mm a').format(widget.task!.createdAtTime).toString();
    }
  }

  //Show Selected Date as String Format
  String showDate(DateTime? date){
    if(widget.task?.createdAtDate==null){
      if(date==null){
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      }else{
        return DateFormat.yMMMEd().format(date).toString();
      }

    }else{
      return  DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  //Show Selected Date as DateFormat for init Time
  DateTime showDateasDateTime(DateTime? date){
    if(widget.task?.createdAtDate==null){
      if(date==null){
        return DateTime.now();
      }else{
        return date;
      }
    }else{
      return widget.task!.createdAtDate;
    }
  }

  //if any task already exist return true otherwise false
  bool isTaskAlreadyExist(){
    if(widget.titleTaskController?.text==null &&widget.descriptionTaskController?.text==null){
      return true;
    }else{
      return false;
    }
  }

  //Main Function for creating or updating tasks
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate(){

    ///Here We Update Current Task
    if(widget.titleTaskController?.text != null && widget.descriptionTaskController?.text !=null){
      try{
        widget.titleTaskController?.text=title;
        widget.descriptionTaskController?.text=subtitle;

        widget.task?.save();
        Navigator.pop(context);
      }catch(e){
        updateTaskWarning(context);
      }

    }else{
      if(title != null && subtitle!=null){
        var task=Task.create(
            title: title,
            subtitle: subtitle,
          createdAtDate: date,
          createdAtTime: time,
        );
        ///We are adding this new task to hive Db using inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.pop(context);
      }else{
        ///Warning
        emptyWarning(context);
      }
    }
  }


  ///Delete Task
  dynamic deleteTask(){
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        /// AppBar
        appBar: TaskViewAppBar(),

        /// Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Top Size Texts
                _buildTopSizeTexts(textTheme: textTheme),

                /// Main Task View Activity
                _buildMainTaskViewActivity(context, textTheme),

                /// Bottom Side Buttons
                _buildBottomSideButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Side Buttons
  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment:isTaskAlreadyExist()? MainAxisAlignment.center: MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()?Container():
          /// Delete Current Task Button
          MaterialButton(
            onPressed: () {
              deleteTask();
              Navigator.pop(context);
            },
            minWidth: 150,
            color: Colors.white,
            height: 55,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Icon(Icons.close, color: AppColors.primaryColor),
                SizedBox(width: 5),
                const Text(AppStr.deleteTask, style: TextStyle(color: AppColors.primaryColor)),
              ],
            ),
          ),

          /// Add Or Update Button
          MaterialButton(
            onPressed: () {
              /// Add Or Update Task Activity
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            height: 55,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 5),
                 Text(isTaskAlreadyExist()?
                    AppStr.addTaskString:AppStr.updateTaskString, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Main Task View Activity
  Widget _buildMainTaskViewActivity(BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(AppStr.titleOfTitleTextField, style: textTheme.headlineMedium),
          ),

          /// Task Title
          RepTextField(controller:
          widget.titleTaskController,
            onfieldSubmitted: (String inputTitle) {
              title=inputTitle;
            },
            onChanged: (String inputTitle) {
              title=inputTitle;
            },
          ),


          10.h,

          /// Task Description
          RepTextField(controller:
          widget.descriptionTaskController,
            isForDescription: true,
            onfieldSubmitted: (String inputsubtitle) {
              subtitle=inputsubtitle;
            },
            onChanged: (String inputsubtitle) {
              subtitle=inputsubtitle;
            },
          ),

          /// Time Selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 280,
                  child: TimePickerWidget(
                    initDateTime: showDateasDateTime(time),
                    onChange: (_, __) {},
                    dateFormat: "HH:mm",
                    onConfirm: (dateTime, __) {
                      setState(() {
                        if(widget.task?.createdAtTime==null){
                          time=dateTime;
                        }else{
                          widget.task!.createdAtTime=dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            title: AppStr.timeString, time: showTime(time),
          ),

          /// Date Selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030, 10, 5),
                minDateTime: DateTime.now(),
                initialDateTime:showDateasDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if(widget.task?.createdAtDate==null){
                      date=dateTime;
                    }else{
                      widget.task!.createdAtDate=dateTime;
                    }
                  });
                },
              );
            },
            title: AppStr.dateString, time:showDate(date),
            isTime: true,
          ),
        ],
      ),
    );
  }

  /// Top Size Texts
  Widget _buildTopSizeTexts({required TextTheme textTheme}) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          /// Yeni Görev Ekle Yada Görevi Güncelle
          RichText(
            text: TextSpan(
              text:isTaskAlreadyExist()?
              AppStr.addNewTask:AppStr.updateCurrentTask,
              style: textTheme.titleLarge,
              children: [
                TextSpan(
                  text: AppStr.taskStrnig,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
