import 'package:tflite_flutter/tflite_flutter.dart';

class HeartMLService {
  static final HeartMLService _instance = HeartMLService._internal();
  factory HeartMLService() => _instance;
  HeartMLService._internal();

  late Interpreter _interpreter;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    _interpreter = await Interpreter.fromAsset('assets/model_converted.tflite');
    _loaded = true;
  }

  double predict(List<double> input) {
    final inputTensor = [input];
    final output = List.generate(1, (_) => List.filled(1, 0.0));
    _interpreter.run(inputTensor, output);
    return output[0][0];
  }

  void dispose() {
    _interpreter.close();
  }
}
