import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/components/constant.dart';
import 'package:todolist/cubit/mainCubit.dart';
import 'package:todolist/states/mainAppStates.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
   Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, MainAppStates>(
        builder: (context, state) {
          var done = AppCubit.get(context).done;
          return SafeArea(
              child: ConditionalBuilder(
            condition: done.isNotEmpty,
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
                              done[index]['time'],
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
                                  done[index]['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  done[index]['date'],
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
                                    id: done[index]['id'],
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
                  itemCount: done.length),
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