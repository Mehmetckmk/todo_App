import 'package:flutter/cupertino.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../main.dart';
import 'app_str.dart';

String lottiUrl='assets/lottie/1.json';



///Empty Title or SubTitle Textfield Warning

dynamic emptyWarning(BuildContext context){
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg:'You Must Fill All Fields!',
    corner: 20.0,
    duration: 2000,
    padding: EdgeInsets.all(20),
  );
}


///NoThing Entered When User Try  To Edit Or Update The Current Task
dynamic updateTaskWarning(BuildContext context){
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg:'You Must Edit The Tasks Then Try To Update İt!',
    corner: 20.0,
    duration: 5000,
    padding: EdgeInsets.all(20),
  );
}


///No Task Warning Dialog For Deleting
dynamic noTaskWarning(BuildContext context){
  return PanaraInfoDialog.showAnimatedGrow(
      context,
      title:AppStr.oopsMsg ,
      message:"There is no Task For Delete!\n Try adding some and then try to delete it!",
      buttonText:"Okay" ,
      onTapDismiss:(){
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.warning);
}


///Delete All Task From Db Dialog
dynamic deleteAllTask(BuildContext context){
  return PanaraConfirmDialog.show(
      context,
      title: AppStr.areYouSure,
      message: "Do You really want to delete all tasks? You will no be able to undo this action!",
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      onTapConfirm: (){
        ///We will clear all box data using this command later on
        BaseWidget.of(context).dataStore.box.clear();
        Navigator.pop(context);
      },
      onTapCancel: (){
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}