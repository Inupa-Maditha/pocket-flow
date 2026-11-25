import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String? transactionId;
  final String categoryId;
  final bool isExpense;
  final String title;
  final double transactionAmount;
  final DateTime dateTime;

  const TransactionModel({
    this.transactionId,
    required this.categoryId,
    required this.title,
    required this.transactionAmount,
    required this.dateTime,
    required this.isExpense,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'categoryId': categoryId,
      'isExpense': isExpense,
      'title': title,
      'transactionAmount': transactionAmount,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: id,
      categoryId: map['categoryId'] as String,
      isExpense: map['isExpense'] as bool,
      title: map['title'] as String,
      transactionAmount: (map['transactionAmount'] as num).toDouble(),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }
}
