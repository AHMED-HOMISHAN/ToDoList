import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/components/constant.dart';
import 'package:todolist/cubit/mainCubit.dart';
import 'package:todolist/states/mainAppStates.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, MainAppStates>(
        builder: (context, state) {
          var archive = AppCubit.get(context).archive;
          return SafeArea(
              child: ConditionalBuilder(
            condition: archive.isNotEmpty,
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
                              archive[index]['time'],
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
                                  archive[index]['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  archive[index]['date'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                       
                         
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => verticalSpace,
                  itemCount: archive.length),
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
