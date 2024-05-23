import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/utils/constants.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key,required this.drawKeyer});

  final GlobalKey<SliderDrawerState> drawKeyer;
  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>with SingleTickerProviderStateMixin {
  late AnimationController animateController;
   bool isDraweropen=false;
  @override

  void initState() {
    animateController=AnimationController(vsync: this,
    duration: Duration(seconds: 1));
    super.initState();
  }
  void dispose(){
    animateController.dispose();
    super.dispose();
  }

  ///OntToggle
  void onDraweToggle(){
    setState(() {
      isDraweropen=!isDraweropen;
      if(isDraweropen){
        animateController.forward();
        widget.drawKeyer.currentState!.openSlider();
      }else{
        animateController.reverse();
        widget.drawKeyer.currentState!.closeSlider();
      }
    });
  }


  Widget build(BuildContext context) {
    var base =BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height:130,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ///Menu Icon
           Padding(
             padding: const EdgeInsets.only(left: 18.0),
             child: IconButton(onPressed: onDraweToggle,
                 icon: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: animateController,size: 40,)),
           ),

            ///Trash Icon
            Padding(
              padding:  const EdgeInsets.only(left: 18.0),
              child: IconButton(onPressed: (){
                base.isEmpty ? noTaskWarning(context):deleteAllTask(context);
              },icon:Icon(CupertinoIcons.trash_fill,size:40),),
            ),
          ],
        ),
      ),
    );
  }
}
