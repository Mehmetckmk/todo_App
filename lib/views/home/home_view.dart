import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/extensions/space_exs.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/utils/constants.dart';
import 'package:to_do_app/views/home/component/fab.dart';
import 'package:to_do_app/views/home/component/home_app_bar.dart';
import 'package:to_do_app/views/home/widgets/task_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../utils/app_str.dart';
import 'component/slider_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  ///Check Value of Circle
  dynamic valueOfIndicator(List<Task>task){
      if(task.isNotEmpty){
        return task.length;
  }else{
        return 3;
  }
  }

  ///Check Done Task
  int checkDoneTask(List<Task>tasks){
    int i=0;
    for(Task doneTask in tasks){
      if(doneTask.isCompleted){
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTasks(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();
          ///For sorting list
          tasks.sort((a,b)=>a.createdAtDate.compareTo(b.createdAtDate));
          return Scaffold(
            backgroundColor: Colors.white,
            //FAB
            floatingActionButton: const Fab(),

            //Body
            body: SliderDrawer(
              key: drawerKey,
              isDraggable: false,
              animationDuration: 1000,
              ///Drawer
              slider: CustomDrawer(),
              appBar: HomeAppBar(drawKeyer: drawerKey,),
              ///Main body
              child: _buildHomeBody(
                textTheme,
                base,
                tasks,
              ),
            ),
          );
        });
  }

  ///Home Body
  Widget _buildHomeBody(
      TextTheme textTheme,
      BaseWidget base,
      List<Task>tasks,
      ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          ///Custom App bar
          Container(
            margin: EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Progress Indıcator
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks)/valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),

                //Space
                25.w,

                //Top Level Task info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStr.mainTitle, style: textTheme.displayLarge,),
                    3.h,
                    Text("${checkDoneTask(tasks)} of ${valueOfIndicator(tasks)} task ", style: textTheme.titleMedium,)
                  ],
                )
              ],
            ),
          ),

          //Divider
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Divider(
              thickness: 2, indent: 100,
            ),
          ),

          ///Tasks
          SizedBox(
            width: double.infinity,
            height: 450,
            child: tasks.isNotEmpty ?
            ///Task List İs Not Empty
            ListView.builder(
                itemCount: tasks.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return Dismissible(
                    direction: DismissDirection.horizontal,
                    onDismissed: (_) {
                      /// We will remove current task from DB
                      base.dataStore.deleteTask(task: task);
                    },
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,),
                        8.w,
                        const Text(AppStr.deletedTask, style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                    key: Key(task.id,),
                    child: TaskWidget(task: task,),
                  );
                }) :
            ///Task List İs Empty
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Lottie Anime
                FadeIn(
                  child: SizedBox(width: 200, height: 200,
                    child: Lottie.asset(lottiUrl,
                      animate: tasks.isNotEmpty ? false : true,
                    ),
                  ),
                ),
                ///Sub Text
                FadeInUp(from: 30,
                  child: const Text(AppStr.doneAllTask),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
