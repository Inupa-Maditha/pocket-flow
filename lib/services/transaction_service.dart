import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pocket_flow/models/transaction_model.dart';

class TransactionService {
  static CollectionReference<Map<String, dynamic>> get _path {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions');
  }

  static Future<bool> createTransaction(TransactionModel model) async {
    try {
      final doc = _path.doc();
      Map<String, dynamic> map = model.toMap();
      map['transactionId'] = doc.id;
      await doc.set(map);
      return true;
    } catch (e) {
      debugPrint('create transaction failed: $e');
      return false;
    }
  }

  static Stream<List<TransactionModel>>? getAllTransaction() {
    try {
      return _path.snapshots().map((event) {
        return event.docs.map((e) {
          return TransactionModel.fromMap(e.id, e.data());
        }).toList();
      });
    } catch (e) {
      debugPrint('get transactions failed: $e');
      return null;
    }
  }

  static Future<TransactionModel?> getTransactionByID(String id) async {
    try {
      final object = await _path.doc(id).get();
      if (!object.exists) return null;
      return TransactionModel.fromMap(id, object.data()!);
    } catch (e) {
      debugPrint('read transaction failed: $e');
      return null;
    }
  }

  static Stream<List<TransactionModel>>? getTransactionByCategoryID(String categoryId) {
    try {
      return _path
          .where('categoryId', isEqualTo: categoryId)
          .snapshots()
          .map(
            (snap) => snap.docs
                .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint('read transaction failed: $e');
      return null;
    }
  }

  static Stream<List<TransactionModel>> getTransactionByDateRange(
    DateTime from,
    DateTime to,
  ) {
    return _path
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(to))
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  static Stream<List<TransactionModel>>? getFilteredTransactions(
    DateTime from,
    DateTime to,
    List<String>? categoryId,
    bool? isExpense,
  ) {
    try {
      if (categoryId != null && categoryId.isEmpty) {
        return Stream.value(<TransactionModel>[]);
      }
      Query<Map<String, dynamic>> query = _path;
      if (isExpense != null) {
        query = query.where('isExpense', isEqualTo: isExpense);
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.where('categoryId', whereIn: categoryId);
      }
      query = query.where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
      query = query.where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(to));
      return query
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map(
            (snap) => snap.docs
                .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
                .toList(),
          );
    } catch (e) {
      debugPrint('read transaction failed: $e');
      return null;
    }
  }

  static Stream<List<TransactionModel>> getRecentTransactions({int count = 5}) {
    return _path
        .orderBy('dateTime', descending: true)
        .limit(count)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  static Future<bool> updateTransaction(TransactionModel transaction) async {
    try {
      await _path.doc(transaction.transactionId).update(transaction.toMap());
      return true;
    } catch (e) {
      debugPrint('update transaction failed: $e');
      return false;
    }
  }

  static Future<bool> deleteTransaction(String id) async {
    try {
      await _path.doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('delete transaction failed: $e');
      return false;
    }
  }
}
