import 'package:flutter/material.dart';

class SharedData {
  static ValueNotifier<List<Map<String, dynamic>>> transactions =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  static set setTransactions(List<Map<String, dynamic>> newList) {
    transactions.value = List.from(newList);
  }
}
