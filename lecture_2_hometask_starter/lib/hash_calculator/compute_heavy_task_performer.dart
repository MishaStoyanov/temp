/*import 'package:flutter/foundation.dart';
import 'package:lecture_2_hometask_starter/constants.dart';
import 'package:lecture_2_hometask_starter/hash_calculator/heavy_task_performer.dart';
import 'package:lecture_2_hometask_starter/helpers/random_number_hash_calculator.dart';

class ComputeHeavyTaskPerformer implements HeavyTaskPerformer {
  @override
  Future<String> doSomeHeavyWork() async {
    return compute<int, String>(
        _calculateRandomNumberHash, DefaultIterationsCount);
  }

  static String _calculateRandomNumberHash(int iterationsCount) =>
      RandomNumberHashCalculator()
          .calculateRandomNumberHash(iterationsCount: iterationsCount);

  @override
  void stopDoHeavyWork() {}
}
*/