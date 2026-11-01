import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/paddings.dart';

class TransactionFilterDashBoard extends StatefulWidget {
  const TransactionFilterDashBoard({super.key});

  @override
  State<TransactionFilterDashBoard> createState() => _TransactionFilterDashBoardState();
}

class _TransactionFilterDashBoardState extends State<TransactionFilterDashBoard> {
  //  Useful Variabals
  //  List<Map<String, dynamic>> selectedCategories
  //  DateTimeRange selectedDateRange
  //  List<Map<String, dynamic>> allCategories

  late int selectedBoxID;

  // Dummy Data Lis
  List<Map<String, dynamic>> allCategories = [
    {
      'categoryName': 'Category One',
      'categoryIcon': Icons.settings,
      'categoryColor': Colors.blue,
      'isIncome': true,
    },
    {
      'categoryName': 'Category Two',
      'categoryIcon': Icons.settings,
      'categoryColor': Colors.red,
      'isIncome': true,
    },
    {
      'categoryName': 'Category Three',
      'categoryIcon': Icons.settings,
      'categoryColor': Colors.green,
      'isIncome': false,
    },
    {
      'categoryName': 'Category Four',
      'categoryIcon': Icons.settings,
      'categoryColor': Colors.yellow,
      'isIncome': false,
    },
    {
      'categoryName': 'Category Five',
      'categoryIcon': Icons.settings,
      'categoryColor': Colors.grey,
      'isIncome': true,
    },
  ];
  List<Map<String, dynamic>> checkBoxCategories = [];
  List<Map<String, dynamic>> selectedCategories = [];

  //  Examples Types for checkBoxCategories and selectedCategories List

  // checkBoxCategories = [
  //   {
  //     'isChecked': true,
  //     'category': {
  //       {
  //         'categoryName': 'Category Five',
  //         'categoryIcon': Icons.settings,
  //         'categoryColor': Colors.grey,
  //         'isIncome': true,
  //       },
  //     },
  //   },
  // ];
  // selectedCategories = [
  //   {
  //     'categoryName': 'Category Five',
  //     'categoryIcon': Icons.settings,
  //     'categoryColor': Colors.grey,
  //     'isIncome': true,
  //   },
  // ];

  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
    end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );

  Widget _trxSelector(double deviceWidth, int componentID, String title, IconData? icon) {
    bool isSelected = componentID == selectedBoxID;
    List<Widget> text = [];
    if (icon != null) {
      text.insert(
        0,
        Icon(icon, color: (isSelected) ? Colors.white : Colors.grey, size: 18),
      );
    }
    text.add(
      Text(
        title,
        style: TextStyle(
          color: (isSelected) ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: deviceWidth / 7 * 2,
      decoration: BoxDecoration(
        color: (isSelected) ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(CustomSize.defaultBorderRadious),
        border: Border.all(color: (isSelected) ? Colors.blue : Colors.grey, width: 2),
      ),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: text),
      ),
    );
  }

  Widget _miniCategoryCard(
    String categoryName,
    IconData categoryIcon,
    Color categoryColor,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CustomSize.defaultBorderRadious - 6),
        border: Border.all(color: categoryColor, width: 2),
        color: Colors.grey.withAlpha(25),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(categoryIcon, size: 20, color: categoryColor),
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
              child: Icon(Icons.close, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _dateRangePicker() async {
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

  @override
  void initState() {
    super.initState();
    selectedBoxID = 0;
    selectedCategories = List.from(allCategories);
    for (int i = 0; i < allCategories.length; i++) {
      checkBoxCategories.add({'isChecked': true, 'category': allCategories[i]});
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(CustomSize.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CustomSize.defaultBorderRadious),
        border: Border.all(color: Colors.grey, width: 2),
        color: Colors.grey.withAlpha(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _dateRangePicker(),
                child: Container(
                  width: (deviceWidth < 412) ? 226 : deviceWidth * 0.55,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(CustomSize.defaultBorderRadious),
                    color: Colors.grey.withAlpha(20),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.calendar_month, size: 16, color: Colors.black54),
                      Text(
                        '${selectedDateRange.start.year},${selectedDateRange.start.month.toString().padLeft(2, '0')},${selectedDateRange.start.day.toString().padLeft(2, '0')} — ${selectedDateRange.end.year},${selectedDateRange.end.month.toString().padLeft(2, '0')},${selectedDateRange.end.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 16),
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
                                          'categoryName':
                                              checkBoxCategories[i]['category']['categoryName'],
                                          'categoryIcon':
                                              checkBoxCategories[i]['category']['categoryIcon'],
                                          'categoryColor':
                                              checkBoxCategories[i]['category']['categoryColor'],
                                          'isIncome':
                                              checkBoxCategories[i]['category']['isIncome'],
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
                    borderRadius: BorderRadius.circular(CustomSize.defaultBorderRadious),
                    color: Colors.grey.withAlpha(20),
                    border: Border.all(color: Colors.grey, width: 2),
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
                      Icon(Icons.keyboard_arrow_down, size: 16),
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
                          'categoryName':
                              checkBoxCategories[i]['category']['categoryName'],
                          'categoryIcon':
                              checkBoxCategories[i]['category']['categoryIcon'],
                          'categoryColor':
                              checkBoxCategories[i]['category']['categoryColor'],
                          'isIncome': checkBoxCategories[i]['category']['isIncome'],
                        });
                      }
                    });
                  }
                },
                child: _trxSelector(deviceWidth, 0, 'Both', null),
              ),
              InkWell(
                onTap: () {
                  if (selectedBoxID != 1) {
                    setState(() {
                      selectedBoxID = 1;
                      checkBoxCategories.clear();
                      for (int i = 0; i < allCategories.length; i++) {
                        if (allCategories[i]['isIncome']) {
                          checkBoxCategories.add({
                            'isChecked': true,
                            'category': allCategories[i],
                          });
                        }
                      }
                      selectedCategories.clear();
                      for (int i = 0; i < checkBoxCategories.length; i++) {
                        selectedCategories.add({
                          'categoryName':
                              checkBoxCategories[i]['category']['categoryName'],
                          'categoryIcon':
                              checkBoxCategories[i]['category']['categoryIcon'],
                          'categoryColor':
                              checkBoxCategories[i]['category']['categoryColor'],
                          'isIncome': checkBoxCategories[i]['category']['isIncome'],
                        });
                      }
                    });
                  }
                },
                child: _trxSelector(deviceWidth, 1, 'Income', Icons.arrow_upward),
              ),
              InkWell(
                onTap: () {
                  if (selectedBoxID != 2) {
                    setState(() {
                      selectedBoxID = 2;
                      checkBoxCategories.clear();
                      for (int i = 0; i < allCategories.length; i++) {
                        if (!allCategories[i]['isIncome']) {
                          checkBoxCategories.add({
                            'isChecked': true,
                            'category': allCategories[i],
                          });
                        }
                      }
                      selectedCategories.clear();
                      for (int i = 0; i < checkBoxCategories.length; i++) {
                        selectedCategories.add({
                          'categoryName':
                              checkBoxCategories[i]['category']['categoryName'],
                          'categoryIcon':
                              checkBoxCategories[i]['category']['categoryIcon'],
                          'categoryColor':
                              checkBoxCategories[i]['category']['categoryColor'],
                          'isIncome': checkBoxCategories[i]['category']['isIncome'],
                        });
                      }
                    });
                  }
                },
                child: _trxSelector(deviceWidth, 2, 'Expense', Icons.arrow_downward),
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
                width: deviceWidth * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    CustomSize.defaultBorderRadious - 4,
                  ),
                  border: Border.all(color: Colors.grey, width: 2),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: selectedCategories.length,
                  itemBuilder: (context, index) {
                    return _miniCategoryCard(
                      selectedCategories[index]['categoryName'],
                      selectedCategories[index]['categoryIcon'],
                      selectedCategories[index]['categoryColor'],
                      index,
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedBoxID = 0;
                    selectedDateRange = DateTimeRange(
                      start: DateTime(
                        DateTime.now().year,
                        DateTime.now().month - 1,
                        DateTime.now().day,
                      ),
                      end: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ),
                    );
                    selectedCategories.clear();
                    checkBoxCategories.clear();
                    for (int i = 0; i < allCategories.length; i++) {
                      checkBoxCategories.add({
                        'isChecked': false,
                        'category': allCategories[i],
                      });
                    }
                  });
                },
                child: Text(
                  'Clear all',
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
