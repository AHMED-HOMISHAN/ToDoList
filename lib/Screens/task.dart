import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/components/constant.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:todolist/cubit/mainCubit.dart';
import 'package:todolist/states/mainAppStates.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, MainAppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).tasks;
          return SafeArea(
              child: ConditionalBuilder(
            condition: tasks.isNotEmpty,
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(7),
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: primaryColor,
                            child: Text(
                              tasks[index]['time'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                          horzintalSpace,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tasks[index]['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  tasks[index]['date'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          horzintalSpace,
                          IconButton(
                              onPressed: () {
                                AppCubit.get(context).updateData(
                                    id: tasks[index]['id'],
                                    status: 1,
                                    context: context,
                                    message: 'Add to Done List Successfully');
                              },
                              icon: const Icon(Icons.task_alt)),
                          IconButton(
                              onPressed: () {
                                AppCubit.get(context).updateData(
                                    id: tasks[index]['id'],
                                    status: 2,
                                    context: context,
                                    message:
                                        'Add to Archive List Successfully');
                              },
                              icon: const Icon(Icons.archive_outlined)),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => verticalSpace,
                  itemCount: tasks.length),
            ),
            fallback: (BuildContext context) => const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          ));
        },
        listener: (context, state) {});
  }
}
