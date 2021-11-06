import 'package:flutter/material.dart';
import 'package:tasky_watcher_app/Services/service.dart';
import 'package:tasky_watcher_app/Utils/colors.dart';

import 'home_view.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({Key? key}) : super(key: key);

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  bool isUploadingTask = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TaskService taskService = TaskService();
  @override
  Widget build(BuildContext context) {
    TextStyle headersStyle = Theme.of(context).textTheme.bodyText2!.copyWith(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700);
    return Scaffold(
      // backgroundColor: createTaskBackgroungColor,
      // appBar: AppBar(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: createTaskBackgroungColor,
          // padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                // margin: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "What to do ?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Title",
                        style: headersStyle,
                      ),
                    ),
                    Material(
                      color: textFielColor,
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                              labelText: "Enter title here",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Description",
                        style: headersStyle,
                      ),
                    ),
                    Material(
                      color: textFielColor,
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                              labelText: "Enter title here",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    isUploadingTask
                        ? const Center(child: CircularProgressIndicator())
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                isUploadingTask = true;
                              });
                              await taskService.postTask(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  isCompleted: false);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Task added succesfully"),
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HomeView()),
                                  (route) => false);
                              setState(() {
                                isUploadingTask = false;
                              });
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: buttonColor,
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text("Save"),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
