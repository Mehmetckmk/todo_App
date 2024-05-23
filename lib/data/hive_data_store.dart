import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/task.dart';


///All the [CRUD] operation Metgod For Hive Db
class HiveDataStore{

  ///Box Name String
  static const boxName='taskBox';

  ///Our Current Box With All The Saved Data İnside - Box<Task>
  final Box<Task>box =Hive.box<Task>(boxName);


  ///Add New Task To Box
  Future<void>addTask({required Task task})async{
    await box.put(task.id,task);
  }

  ///Show Task
  Future<Task?> getTask({required String id})async{
    return box.get(id);
  }


  ///Update Task
  Future<void> updateTask({required Task task})async{
    await task.save();
  }

  ///Delete Task
  Future<void> deleteTask({required Task task})async{
    await task.delete();
  }


  ///Listen to Box Changes
  ///using This Metot We WillListen To Box Changes And Updte The Ui Accordingly
  ValueListenable<Box<Task>>listenToTasks()=>box.listenable();


}