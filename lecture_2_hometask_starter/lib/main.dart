// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_2_hometask_starter/hash_calculator/compute_heavy_task_performer.dart';
import 'package:lecture_2_hometask_starter/hash_calculator/heavy_task_performer.dart';

import 'hash_calculator/spawned_isolate_task_performer.dart';

enum HeavyWorkEvent { event_working, event_StopWorking }

class HeavyWorkBloc extends Bloc<HeavyWorkEvent, String> {
  SpawnedIsolateTaskPerformer taskPerformer = SpawnedIsolateTaskPerformer();
  String _res = '';

  HeavyWorkBloc() : super('');

  @override
  Stream<String> mapEventToState(HeavyWorkEvent event) async* {
    if (event == HeavyWorkEvent.event_working) {
      //print('Got event working');
      _res = await taskPerformer.doSomeHeavyWork();
    } else {
      // print('Got event stop!');
      taskPerformer.stopDoHeavyWork();
      _res = 'Stopped';
    }
    /*_res = (event == HeavyWorkEvent.event_working)
        ? await taskPerformer.doSomeHeavyWork()
        : await taskPerformer.stopDoHeavyWork();*/
    yield _res;
  }
}

void main() {
  runApp(
    MyApp(
      taskPerformer: SpawnedIsolateTaskPerformer(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.taskPerformer,
  }) : super(key: key);

  final HeavyTaskPerformer taskPerformer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (_) => HeavyWorkBloc(),
          // ignore: prefer_const_constructors
          child: MyHomePage(
            title: "Flutter Demo Home Page",
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String heavyTaskResult = '';
  bool isPerformingTask = false;
  final String stopHeavyTask = 'Stop Heavy Task!';
  @override
  Widget build(BuildContext context) {
    HeavyWorkBloc _bloc = BlocProvider.of<HeavyWorkBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: BlocBuilder<HeavyWorkBloc, String>(
        builder: (context, heavyTaskResult) => Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Heavy task result is equal to: $heavyTaskResult',
                textAlign: TextAlign.center,
              ),
              Row(
                children: <Widget>[
                  isPerformingTask
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            isPerformingTask = true;
                            _bloc.add(HeavyWorkEvent.event_working);
                          },
                          child: const Text('Perform Heavy Task'),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _bloc.add(HeavyWorkEvent.event_StopWorking);
                      isPerformingTask = false;
                    },
                    child: Text(stopHeavyTask), //Add button to stop heavy task.
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
