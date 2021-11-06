import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tasky_watcher_app/Model/taskyModel.dart';
import 'package:tasky_watcher_app/Services/service.dart';
import 'package:tasky_watcher_app/Utils/colors.dart';
import 'package:tasky_watcher_app/Views/create_task_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Duration initialDelay = const Duration(seconds: 0);

  TaskService taskService = TaskService();
  Future<TaskyManagerApi>? data;
  @override
  void initState() {
    // taskService.getAllTasks();
    data = taskService.getAllTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();

    var formatDate = DateFormat(' kk:mm a').format(date).toString();
    return Scaffold(
      backgroundColor: appbackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(formatDate,
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              SizedBox(
                width: double.infinity,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 15,
                        ),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) => DelayedDisplay(
                        slidingBeginOffset: const Offset(0.34, 0.3),
                        delay: Duration(
                            seconds: initialDelay.inSeconds + 0.5.toInt()),
                        child: const OnGoingProjects())),
                height: 110,
                // color: Colors.red,
              ),
              Slider(value: 0, onChanged: (value) {}),
              Expanded(
                child: FutureBuilder<TaskyManagerApi>(
                    future: data,
                    builder:
                        (context, AsyncSnapshot<TaskyManagerApi> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data == null) {
                        return const Text(
                          'Something went wrong',
                          style: TextStyle(fontSize: 30),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, index) => DelayedDisplay(
                            delay: Duration(
                                seconds: initialDelay.inSeconds + index),
                            child: AllTask(
                                isCompltede:
                                    !snapshot.data!.data![index].isCompleted,
                                data: snapshot.data!.data![index])),
                      );
                    }
                    // AllTask()
                    ),
              ),
              CalendarAgenda(
                calendarEventSelectedColor: Colors.black,
                backgroundColor: appbackgroundColor,
                dateColor: Colors.black,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 140)),
                lastDate: DateTime.now().add(const Duration(days: 4)),
                onDateSelected: (date) {},
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff7758A5),
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: CreateTaskView()));
        },

        label: const Icon(Icons.add),
        // child: Icon(Icons.add),
      ),
    );
  }
}

class AllTask extends StatefulWidget {
  AllTask({Key? key, required this.data, required this.isCompltede})
      : super(key: key);
  bool isCompltede;

  // bool isCompleted = false;
  Datum data;

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Material(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color:
                  widget.data.isCompleted ? completedTaskColor : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(
                      widget.data.title,
                    )),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(widget.data.isCompleted
                                      ? "This task is marked completed. Are you sure you want to undo it ?"
                                      : "Are you sure you want to mark this Task as Complete ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await taskService
                                            .updateTask(
                                                id: widget.data.id,
                                                isCompleted:
                                                    !widget.data.isCompleted)
                                            .then((value) {
                                          setState(() {});

                                          // Navigator.pop(context);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const HomeView()),
                                              (route) => false);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(widget
                                                      .data.isCompleted
                                                  ? "Task marked as not completed"
                                                  : "Task Completed succesfully"),
                                            ),
                                          );
                                        });
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          // Navigator.pop(context);
                                        },
                                        child: const Text("No")),
                                  ],
                                ));
                      },
                      child: Icon(
                        widget.data.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 30,
                        color: widget.data.isCompleted ? null : Colors.red,
                      ),
                    ),
                    // Icon(Icons.circle_outlined),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Text(
                              "Are you sure you want to delete this Task?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await taskService
                                    .deletedTask(widget.data.id)
                                    .then((value) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const HomeView()),
                                      (route) => false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              "Task Delelted succesfully")));
                                });
                              },
                              child: const Text("Yes"),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No")),
                          ],
                        ));
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}

class OnGoingProjects extends StatelessWidget {
  const OnGoingProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffF58967),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 120,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "hgjjjg",
                  style: TextStyle(color: appbackgroundColor),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Ketchen Stuff",
                style: TextStyle(color: appbackgroundColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "10/25",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
