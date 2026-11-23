import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_flow/constants/app_theme.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/models/category_model.dart';
import 'package:pocket_flow/services/category_service.dart';
import 'package:pocket_flow/services/transaction_service.dart';
import 'package:pocket_flow/shared/shared_data.dart';

class TransactionFilterDashBoard extends StatefulWidget {
  const TransactionFilterDashBoard({super.key});

  @override
  State<TransactionFilterDashBoard> createState() => _TransactionFilterDashBoardState();
}

class _TransactionFilterDashBoardState extends State<TransactionFilterDashBoard> {
  late int selectedBoxID;
  late bool isSearchClicked;

  List<Map<String, dynamic>> allCategories = [];
  List<Map<String, dynamic>> checkBoxCategories = [];
  List<Map<String, dynamic>> selectedCategories = [];
  List<Map<String, dynamic>> displayTransactions = [];

  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
    end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  Widget trxSelector(double deviceWidth, int componentID, String title, IconData? icon) {
    bool isSelected = componentID == selectedBoxID;
    List<Widget> text = [];
    if (icon != null) {
      text.insert(
        0,
        Icon(
          icon,
          color: (isSelected) ? AppColors.surface : AppColors.textSecondary,
          size: 18,
        ),
      );
    }
    text.add(
      Text(
        title,
        style: TextStyle(
          color: (isSelected) ? AppColors.surface : AppColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: deviceWidth / 7 * 2,
      decoration: BoxDecoration(
        color: (isSelected) ? AppColors.primary : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: (isSelected) ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: text),
      ),
    );
  }

  Widget miniCategoryCard(
    String categoryName,
    int categoryIcon,
    String categoryColor,
    int index,
  ) {
    final color = int.parse('0xff$categoryColor');
    return Container(
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border, width: 1),
        color: AppColors.surface,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              IconData(categoryIcon, fontFamily: 'MaterialIcons'),
              size: 20,
              color: Color(color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(categoryName),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  String removedCategoryName = selectedCategories[index]['categoryName'];
                  for (int i = 0; i < checkBoxCategories.length; i++) {
                    if (checkBoxCategories[i]['category']['categoryName'] ==
                        removedCategoryName) {
                      checkBoxCategories[i]['isChecked'] = false;
                    }
                  }
                  selectedCategories.removeAt(index);
                });
              },
              child: Icon(Icons.close, size: 20, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> dateRangePicker() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(
        DateTime.now().year - 1,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime.now(),
    );
    if (result != null) {
      setState(() {
        selectedDateRange = result;
      });
    }
  }

  void getInitData() async {
    final categories = await CategoryService.getAllCategories().first;
    final data = await TransactionService.getTransactionByDateRange(
      selectedDateRange.start,
      selectedDateRange.end,
    ).first;

    allCategories.clear();
    selectedCategories.clear();
    checkBoxCategories.clear();
    displayTransactions.clear();

    for (var element in categories) {
      final map = element.toMap();
      allCategories.add(map);
      checkBoxCategories.add({'isChecked': true, 'category': map});
    }
    selectedCategories = List.from(allCategories);

    for (var element in data) {
      CategoryModel? category;
      final String time = DateFormat('hh:mm a').format(element.dateTime);
      final String date = DateFormat('yyyy-MM-dd').format(element.dateTime);

      for (var i = 0; i < categories.length; i++) {
        if (element.categoryId == categories[i].id) {
          category = categories[i];
          break;
        }
      }
      if (category != null) {
        displayTransactions.add({
          'id': element.transactionId,
          'title': element.title,
          'price': element.transactionAmount,
          'time': time,
          'date': date,
          'categoryName': category.categoryName,
          'categoryIcon': category.categoryIcon,
          'categoryColor': category.categoryColor,
          'isExpense': element.isExpense,
        });
      }
    }
    setState(() {
      SharedData.setTransactions = displayTransactions;
    });
  }

  void getFilteredData() async {
    displayTransactions.clear();
    List<String> ids = [];

    for (var element in selectedCategories) {
      ids.add(element['id']);
    }
    final data = await TransactionService.getFilteredTransactions(
      selectedDateRange.start,
      selectedDateRange.end,
      ids,
      null,
    )!.first;

    for (var element in data) {
      Map<String, dynamic>? category;
      final String time = DateFormat('hh:mm a').format(element.dateTime);
      final String date = DateFormat('yyyy-MM-dd').format(element.dateTime);

      for (var i = 0; i < selectedCategories.length; i++) {
        if (element.categoryId == selectedCategories[i]['id']) {
          category = selectedCategories[i];
          break;
        }
      }
      if (category != null) {
        displayTransactions.add({
          'id': element.transactionId,
          'title': element.title,
          'price': element.transactionAmount,
          'time': time,
          'date': date,
          'categoryName': category['categoryName'],
          'categoryIcon': category['categoryIcon'],
          'categoryColor': category['categoryColor'],
          'isExpense': element.isExpense,
        });
      }
    }
    setState(() {
      isSearchClicked = false;
      SharedData.setTransactions = displayTransactions;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedBoxID = 0;
    isSearchClicked = false;
    getInitData();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(CustomSize.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1),
        color: AppColors.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => dateRangePicker(),
                child: Container(
                  width: (deviceWidth < 412) ? 226 : deviceWidth * 0.55,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    color: AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      Text(
                        '${selectedDateRange.start.year},${selectedDateRange.start.month.toString().padLeft(2, '0')},${selectedDateRange.start.day.toString().padLeft(2, '0')} — ${selectedDateRange.end.year},${selectedDateRange.end.month.toString().padLeft(2, '0')},${selectedDateRange.end.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setDialogState) {
                          return AlertDialog(
                            title: const Text('Select Categories'),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * 1 / 3,
                              child: ListView.builder(
                                itemCount: checkBoxCategories.length,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                    value: checkBoxCategories[index]['isChecked'],
                                    title: Text(
                                      checkBoxCategories[index]['category']['categoryName'],
                                    ),
                                    onChanged: (value) {
                                      setDialogState(() {
                                        checkBoxCategories[index]['isChecked'] =
                                            !checkBoxCategories[index]['isChecked'];
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategories.clear();
                                    for (int i = 0; i < checkBoxCategories.length; i++) {
                                      if (checkBoxCategories[i]['isChecked']) {
                                        selectedCategories.add({
                                          'id': checkBoxCategories[i]['category']['id'],
                                          'categoryName':
                                              checkBoxCategories[i]['category']['categoryName'],
                                          'categoryIcon':
                                              checkBoxCategories[i]['category']['categoryIcon'],
                                          'categoryColor':
                                              checkBoxCategories[i]['category']['categoryColor'],
                                          'isExpense':
                                              checkBoxCategories[i]['category']['isExpense'],
                                        });
                                      }
                                    }
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  width: (deviceWidth < 412) ? 123 : deviceWidth * 0.30,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    color: AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: CustomSize.defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (selectedBoxID != 0) {
                    setState(() {
                      selectedBoxID = 0;
                      checkBoxCategories.clear();
                      for (int i = 0; i < allCategories.length; i++) {
                        checkBoxCategories.add({
                          'isChecked': true,
                          'category': allCategories[i],
                        });
                      }
                      selectedCategories.clear();
                      for (int i = 0; i < checkBoxCategories.length; i++) {
                        selectedCategories.add({
                          'id': checkBoxCategories[i]['category']['id'],
                          'categoryName':
                              checkBoxCategories[i]['category']['categoryName'],
                          'categoryIcon':
                              checkBoxCategories[i]['category']['categoryIcon'],
                          'categoryColor':
                              checkBoxCategories[i]['category']['categoryColor'],
                          'isExpense': checkBoxCategories[i]['category']['isExpense'],
                        });
                      }
                    });
                  }
                },
                child: trxSelector(deviceWidth, 0, 'Both', null),
              ),
              InkWell(
                onTap: () {
                  if (selectedBoxID != 1) {
                    setState(() {
                      selectedBoxID = 1;
                      checkBoxCategories.clear();
                      for (int i = 0; i < allCategories.length; i++) {
                        if (!allCategories[i]['isExpense']) {
                          checkBoxCategories.add({
                            'isChecked': true,
                            'category': allCategories[i],
                          });
                        }
                      }
                      selectedCategories.clear();
                      for (int i = 0; i < checkBoxCategories.length; i++) {
                        selectedCategories.add({
                          'id': checkBoxCategories[i]['category']['id'],
                          'categoryName':
                              checkBoxCategories[i]['category']['categoryName'],
                          'categoryIcon':
                              checkBoxCategories[i]['category']['categoryIcon'],
                          'categoryColor':
                              checkBoxCategories[i]['category']['categoryColor'],
                          'isExpense': checkBoxCategories[i]['category']['isExpense'],
                        });
                      }
                    });
                  }
                },
                child: trxSelector(deviceWidth, 1, 'Income', Icons.arrow_upward),
              ),
              InkWell(
                onTap: () {
                  if (selectedBoxID != 2) {
                    setState(() {
                      selectedBoxID = 2;
                      checkBoxCategories.clear();
                      for (int i = 0; i < allCategories.length; i++) {
                        if (allCategories[i]['isExpense']) {
                          checkBoxCategories.add({
                            'isChecked': true,
                            'category': allCategories[i],
                          });
                        }
                      }
                      selectedCategories.clear();
                      for (int i = 0; i < checkBoxCategories.length; i++) {
                        selectedCategories.add({
                          'id': checkBoxCategories[i]['category']['id'],
                          'categoryName':
                              checkBoxCategories[i]['category']['categoryName'],
                          'categoryIcon':
                              checkBoxCategories[i]['category']['categoryIcon'],
                          'categoryColor':
                              checkBoxCategories[i]['category']['categoryColor'],
                          'isExpense': checkBoxCategories[i]['category']['isExpense'],
                        });
                      }
                    });
                  }
                },
                child: trxSelector(deviceWidth, 2, 'Expense', Icons.arrow_downward),
              ),
            ],
          ),
          SizedBox(height: CustomSize.defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 48,
                padding: EdgeInsets.all(6),
                width: deviceWidth * 0.74,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.border, width: 1),
                  color: AppColors.surfaceVariant,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: selectedCategories.length,
                  itemBuilder: (context, index) {
                    return miniCategoryCard(
                      selectedCategories[index]['categoryName'],
                      selectedCategories[index]['categoryIcon'],
                      selectedCategories[index]['categoryColor'],
                      index,
                    );
                  },
                ),
              ),
              (isSearchClicked)
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      constraints: BoxConstraints(
                        minHeight: 20,
                        minWidth: 20,
                        maxHeight: 35,
                        maxWidth: 35,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        getFilteredData();
                        setState(() {
                          isSearchClicked = true;
                        });
                      },
                      icon: Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
