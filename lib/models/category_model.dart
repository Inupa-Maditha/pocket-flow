class CategoryModel {
  final String? id;
  final String categoryColor;
  final String categoryName;
  final int categoryIcon;
  final bool isExpense;
  const CategoryModel({
    this.id,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.isExpense,
  });

  Map<String, dynamic> toMap() => {
    'isExpense': isExpense,
    'categoryIcon': categoryIcon,
    'categoryColor': categoryColor,
    'categoryName': categoryName,
  };

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      categoryName: map['categoryName'] as String,
      categoryColor: map['categoryColor'] as String,
      categoryIcon: map['categoryIcon'] as int,
      isExpense: map['isExpense'] as bool,
    );
  }
}
