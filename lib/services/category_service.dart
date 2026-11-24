import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/models/category_model.dart';
import 'package:pocket_flow/services/transaction_service.dart';

class CategoryService {
  static CollectionReference<Map<String, dynamic>> get _path {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('categories');
  }

  static Future<bool> createCategory(CategoryModel category) async {
    try {
      final name = category.categoryName.trim().toLowerCase();
      final snap = await _path.get();
      final exists = snap.docs.any(
        (d) => (d.data()['categoryName'] as String).trim().toLowerCase() == name,
      );
      if (!exists) {
        final doc = _path.doc();
        Map<String, dynamic> map = category.toMap();
        map['id'] = doc.id;
        await doc.set(map);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('create category failed: $e');
      return false;
    }
  }

  static Stream<List<CategoryModel>> getAllCategories() {
    return _path.snapshots().map((event) {
      return event.docs.map((e) {
        return CategoryModel.fromMap(e.id, e.data());
      }).toList();
    });
  }

  static Future<CategoryModel?> getCategoryByID(String id) async {
    try {
      final object = await _path.doc(id).get();
      if (!object.exists) return null;
      return CategoryModel.fromMap(id, object.data()!);
    } catch (e) {
      debugPrint('read category failed: $e');
      return null;
    }
  }

  static Stream<List<CategoryModel>> getCategoriesByType(bool isExpense) {
    return _path
        .where('isExpense', isEqualTo: isExpense)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => CategoryModel.fromMap(doc.id, doc.data())).toList(),
        );
  }

  static Future<String> getCategoryIdByName(String categoryName) async {
    final snap = await _path
        .where('categoryName', isEqualTo: categoryName)
        .limit(1)
        .get();

    return snap.docs.first.id;
  }

  static Future<String> getCategoryNameById(String id) async {
    final snap = await _path.where('id', isEqualTo: id).limit(1).get();

    return snap.docs.first.data()['categoryName'];
  }

  static Future<bool> deleteCategory(String id) async {
    try {
      final list = await TransactionService.getTransactionByCategoryID(id)!.first;
      for (var element in list) {
        await TransactionService.deleteTransaction(element.transactionId!);
      }
      await _path.doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('delete category failed: $e');
      return false;
    }
  }

  static Future<bool> updateCategory(CategoryModel category) async {
    try {
      await _path.doc(category.id!).update(category.toMap());
      return true;
    } catch (e) {
      debugPrint('update category failed: $e');
      return false;
    }
  }
}
