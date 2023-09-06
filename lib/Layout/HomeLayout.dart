import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/components/components.dart';
import 'package:todolist/components/constant.dart';
import 'package:todolist/cubit/mainCubit.dart';
import 'package:todolist/states/mainAppStates.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetOpened = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, MainAppStates>(
        listener: (context, state) {
          if (state is AppInsertDataState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('TODO List',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_task_sharp), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavigation(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isBottomSheetOpened) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text,
                            status: 0)
                        .then((value) {
                      isBottomSheetOpened = false;
                      messanger(
                          context: context,
                          message: 'The Task has been added succcessfully',
                          status: true);
                      titleController.text = "";
                      dateController.text = "";
                      timeController.text = "";
                      setState(() {});
                    });
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet((context) {
                    return Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              defaultForm(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  prefixIcon: Icons.text_fields,
                                  label: 'Title',
                                  validate: true,
                                  suffixIconPressed: () {}),
                              verticalSpace,
                              defaultForm(
                                  controller: dateController,
                                  type: TextInputType.text,
                                  validate: true,
                                  prefixIcon: Icons.calendar_month_outlined,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2030-01-01'),
                                    ).then((value) {
                                      dateController.text =
                                          value.toString().substring(0, 9);
                                    });
                                  },
                                  label: 'Date',
                                  suffixIconPressed: () {}),
                              verticalSpace,
                              defaultForm(
                                  controller: timeController,
                                  validate: true,
                                  type: TextInputType.text,
                                  prefixIcon: Icons.watch_later_outlined,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  label: 'Time',
                                  suffixIconPressed: () {}),
                            ]),
                      ),
                    );
                  });
                  isBottomSheetOpened = true;
                  setState(() {});
                }
              },
              child: Icon(
                isBottomSheetOpened ? Icons.add : Icons.edit,
              ),
            ),
          );
        },
      ),
    );
  }
}
