// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:isolate';

import 'package:lecture_2_hometask_starter/hash_calculator/heavy_task_performer.dart';
import 'package:lecture_2_hometask_starter/helpers/random_number_hash_calculator.dart';

import '../constants.dart';

class SpawnedIsolateTaskPerformer implements HeavyTaskPerformer {
  late Isolate isolate;
  late Completer completer;

  @override
  Future<String> doSomeHeavyWork() async {
    var completer = Completer<String>();
    try {
      final spawnerRecievePort = ReceivePort();
      isolate = await Isolate.spawn(
          _establishCommunicationWithSpawner, spawnerRecievePort.sendPort);

      spawnerRecievePort.listen((message) {
        if (message is SendPort) {
          message.send(DefaultIterationsCount);
        }
        if (message is String) {
          completer.complete(message);
        }
      });
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  static void _establishCommunicationWithSpawner(SendPort spawnerSendPort) {
    final spawneeRecievePort = ReceivePort();
    final hashCalculator = RandomNumberHashCalculator();
    spawnerSendPort.send(spawneeRecievePort.sendPort);

    spawneeRecievePort.listen((message) {
      if (message is int) {
        final result =
            hashCalculator.calculateRandomNumberHash(iterationsCount: message);
        spawnerSendPort.send(result);
      }
    });
  }

  @override
  void stopDoHeavyWork() {
    isolate.kill(priority: Isolate.immediate);
  }
}
