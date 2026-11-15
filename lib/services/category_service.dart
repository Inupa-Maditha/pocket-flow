import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/models/category_model.dart';

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
      final doc = _path.doc();
      Map<String, dynamic> map = category.toMap();
      map['id'] = doc.id;
      await doc.set(map);
      return true;
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

  static Future<bool> deleteCategory(String id) async {
    try {
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
