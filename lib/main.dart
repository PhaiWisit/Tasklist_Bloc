import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/screens/tabs_screen.dart';
import 'package:flutter_tasks_app/services/app_router.dart';
import 'package:flutter_tasks_app/services/app_theme.dart';
import 'package:flutter_tasks_app/services/send_order.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:workmanager/workmanager.dart';
import 'blocs/bloc_exports.dart';
import 'models/task.dart';


void sendTask(BuildContext context) {
    // List<Task> favoritTasks = context.read<TasksBloc>().state.favouriteTasks.toList();
    // for(int i=0; i< favoritTasks.length; i++){
    //   log('${i+1}. ${favoritTasks[i].title} \n  ${favoritTasks[i].description}');
    // }

    List<Task> pendingTasks = context.read<TasksBloc>().state.pendingTasks;

    final String favouriteTasksAsString =
        'งานทั้งหมด\n--------------------------' +
            pendingTasks
                .map((task) =>
                    '\nเรื่อง : ${task.title}\nรายละเอียด : ${task.description}')
                .join('\n--------------------------');

    if (pendingTasks.isEmpty) {
      const snackBar = SnackBar(
        content: Text('ไม่มีงานให้ส่งในขณะนี้'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      SendOrder.sendOrder(favouriteTasksAsString);
    }

    log(favouriteTasksAsString);
  }

  void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Native called background task: 1"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  // Workmanager().initialize(
  //   callbackDispatcher, // The top level function, aka callbackDispatcher
  //   isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  // );
  // Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  

  HydratedBlocOverrides.runZoned(
    () => runApp(
      MyApp(
        appRouter: AppRouter(),
      ),
    ),
    storage: storage,
  );

  // HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory: await getApplicationDocumentsDirectory(),
  // );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.appRouter}) : super(key: key);
  final AppRouter appRouter;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TasksBloc()),
        BlocProvider(create: (context) => SwitchBloc()),
      ],
      child: BlocBuilder<SwitchBloc, SwitchState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Tasks App',
            theme: state.switchValue 
              ? AppThemes.appThemeData[AppTheme.darkTheme] 
              : AppThemes.appThemeData[AppTheme.lightTheme],
            home: const TabsScreen(),
            onGenerateRoute: appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}