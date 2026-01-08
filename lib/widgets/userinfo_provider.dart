import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonProvider extends ChangeNotifier {
  String name = "";
  double? age;
  double? weight; // chỉ hiển thị
  double? chest;
  double? bp;
  double? chol;
  double? sugar;
  double? ecg;
  double? angina;
  double? oldpeak;
  double? slope;

  String sex = "male";
  bool isNewSession = false;

  void setNewSession(bool val) {
    isNewSession = val;
    notifyListeners();
  }

  void updateName(String val) {
    name = val;
    notifyListeners();
  }

  void updateField(String key, dynamic value) {
    double? v;
    if (value != null) {
      if (value is num) {
        v = value.toDouble();
      } else {
        v = double.tryParse(value.toString());
      }
    }

    switch (key) {
      case 'age':
        age = v;
        break;
      case 'weight':
        weight = v;
        break;
      case 'chest':
        chest = v;
        break;
      case 'bp':
        bp = v;
        break;
      case 'chol':
        chol = v;
        break;
      case 'sugar':
        sugar = v;
        break;
      case 'ecg':
        ecg = v;
        break;
      case 'angina':
        angina = v;
        break;
      case 'oldpeak':
        oldpeak = v;
        break;
      case 'slope':
        slope = v;
        break;
      case 'sex':
        if (value is String) sex = value;
        break;
    }
    notifyListeners();
  }

  double? getValue(String key) {
    switch (key) {
      case 'age':
        return age;
      case 'weight':
        return weight;
      case 'chest':
        return chest;
      case 'bp':
        return bp;
      case 'chol':
        return chol;
      case 'sugar':
        return sugar;
      case 'ecg':
        return ecg;
      case 'angina':
        return angina;
      case 'oldpeak':
        return oldpeak;
      case 'slope':
        return slope;
      default:
        return null;
    }
  }

  void loadFromFirestore(Map<String, dynamic> data) {
    double d(String k) => (data[k] as num?)?.toDouble() ?? 0.0;

    name = data['name'] ?? "";

    age = d('age');
    weight = d('weight');
    chest = d('chest');
    bp = d('bp');
    chol = d('chol');
    sugar = d('sugar');
    ecg = d('ecg');
    angina = d('angina');
    oldpeak = d('oldpeak');
    slope = d('slope');
    sex = (data['sex'] as String?) ?? "male";

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "weight": weight,
      "sex": sex,
      "chest": chest,
      "bp": bp,
      "chol": chol,
      "sugar": sugar,
      "ecg": ecg,
      "angina": angina,
      "oldpeak": oldpeak,
      "slope": slope,
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  List<double> toTFLiteInput() {
    const means = {
      "age": 53.72,
      "chest": 3.23,
      "bp": 132.15,
      "chol": 210.36,
      "sugar": 0.21,
      "ecg": 0.69,
      "angina": 0.92,
      "oldpeak": 1.62,
      "slope": 1.62,
    };

    const stds = {
      "age": 9.36,
      "chest": 0.93,
      "bp": 18.36,
      "chol": 101.42,
      "sugar": 0.41,
      "ecg": 0.87,
      "angina": 1.08,
      "oldpeak": 1.08,
      "slope": 0.61,
    };

    double scale(String key, double? val) {
      if (val == null) return 0.0;
      return (val - means[key]!) / stds[key]!;
    }

    // Encode sex
    double sexEncoded = (sex.toLowerCase() == "male") ? 1.0 : 0.0;

    return [
      scale('age', age),
      sexEncoded,
      scale('chest', chest),
      scale('bp', bp),
      scale('chol', chol),
      scale('sugar', sugar),
      scale('ecg', ecg),
      scale('angina', angina),
      scale('oldpeak', oldpeak),
      scale('slope', slope),
    ];
  }
}
