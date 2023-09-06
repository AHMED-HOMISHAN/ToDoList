import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/Screens/archive.dart';
import 'package:todolist/Screens/done.dart';
import 'package:todolist/Screens/task.dart';
import 'package:todolist/components/components.dart';
import 'package:todolist/states/mainAppStates.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<MainAppStates> {
  AppCubit() : super(MainAppIntionalState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  late Database db;
  List<Map> tasks = [];
  List<Map> done = [];
  List<Map> archive = [];

  List<Widget> screens = const [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];

  void changeBottomNavigation(int index) {
    currentIndex = index;
    emit(BottomNavigationBarState());
  }

  Future<void> createDatabase() async {
    db = await openDatabase('toDoList.db', version: 1, onCreate: (db, version) {
      db
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status INTEGER)')
          .then((value) {
        emit(AppCreateDataState());
      }).catchError((error) {});
    }, onOpen: (db) {
      getFromLocalDatabase(db);
    });
  }

  Future insertDatabase({
    required String title,
    required String date,
    required String time,
    required int status,
  }) async {
    return await db.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title,date,time,status) VALUES("$title","$date","$time","$status");')
          .then((value) {
        emit(AppInsertDataState());
        getFromLocalDatabase(db);
      });
    }).catchError((error) {});
  }

  void updateData({
    required BuildContext context,
    required int id,
    required int status,
    required String message,
  }) async {
    await db.rawUpdate('UPDATE Tasks SET status= ? WHERE id= ?',
        ['$status', '$id']).then((value) {
      messanger(context: context, message: message);
      getFromLocalDatabase(db);
      emit(AppUpdateDataState());
      emit(AppGetDataState());
    });
  }

  void getFromLocalDatabase(db) {
    db.rawQuery('SELECT * FROM Tasks;').then((value) {
      tasks = [];
      done = [];
      archive = [];
      value.forEach((element) {
        if (element['status'] == 0) {
          tasks.add(element);
        } else if (element['status'] == 1) {
          done.add(element);
        } else {
          archive.add(element);
        }
      });
      emit(AppGetDataState());
    });
  }
}
