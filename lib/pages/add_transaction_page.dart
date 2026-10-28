import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/pages/create_new_category.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _globalKey = GlobalKey<FormState>();

  final _titleControllar = TextEditingController();

  final String _categoryError = 'Please Select category';
  final String _titleError = "Can't be empty";
  final String _timeError = 'Invalid Time';

  List<String> incomeCategoryItems = ['Income 1', 'Income 2', 'Income 3'];
  List<String> expenseCategoryItems = ['Expense 1', 'Expense 2', 'Expense 3'];

  late DateTime dateTime;

  late bool isCategoryValid;
  late bool isTitleValid;
  late bool isTimeValid;
  late bool isExpensePageSelect;

  late int _yearControllar;
  late int _monthControllar;
  late int _dayControllar;
  late int _hourControllar;
  late int _minuteControllar;

  Widget errorBox(bool validation, String errorMessage) {
    return (validation)
        ? SizedBox(height: 0)
        : Text(
            errorMessage,
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  String? selectedCategory;

  Widget categoryBox(bool isIncome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: CustomSize.defaultPadding),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 8),
          child: Text(
            'Select Category',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding * 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.withAlpha(60),
          ),
          child: DropdownButtonFormField<String>(
            items: ((isIncome) ? incomeCategoryItems : expenseCategoryItems)
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            decoration: InputDecoration(border: InputBorder.none),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontSize: 16,
            ),
            onChanged: (value) {
              selectedCategory = value;
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            errorBox(isCategoryValid, _categoryError),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateNewCategory(isExpense: isExpensePageSelect),
                  ),
                );
              },
              icon: Icon(Icons.add_circle_outline, size: 28, color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  Future<DateTime> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(dateTime.year, dateTime.month - 3, dateTime.day),
      lastDate: dateTime,
    );
    if (picked != null) {
      return picked;
    } else {
      return dateTime;
    }
  }

  Future<TimeOfDay> pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      return picked;
    } else {
      return TimeOfDay.now();
    }
  }

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    _yearControllar = dateTime.year;
    _monthControllar = dateTime.month;
    _dayControllar = dateTime.day;
    _hourControllar = dateTime.hour;
    _minuteControllar = dateTime.minute;
    isCategoryValid = true;
    isTitleValid = true;
    isTimeValid = true;
    isExpensePageSelect = true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: CustomSize.defaultPadding,
                  ),
                  child: Text(
                    'Create Transaction',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(height: CustomSize.defaultPadding * 2),
            Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Transaction Type',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 185,
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: AppBar(
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(-20),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(50),
                                border: Border.all(color: Colors.grey, width: 1.25),
                              ),
                              child: TabBar(
                                onTap: (value) {
                                  setState(() {
                                    selectedCategory = null;
                                    switch (value) {
                                      case 0:
                                        isExpensePageSelect = true;
                                        break;
                                      case 1:
                                        isExpensePageSelect = false;
                                        break;
                                      default:
                                        break;
                                    }
                                  });
                                },
                                tabs: [Text('Expense'), Text('Income')],
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                  color: Color.fromARGB(228, 112, 167, 255),
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black87,
                                dividerColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        body: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [categoryBox(false), categoryBox(true)],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: CustomSize.defaultPadding * 2,
                      bottom: 1.5,
                    ),
                    child: Text(
                      'Title',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _titleControllar,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        enabled: true,
                        filled: true,
                        isDense: true,
                        counterText: null,
                        contentPadding: EdgeInsets.all(CustomSize.defaultPadding),
                        hint: Text(
                          'SHORT EATS',
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.black54),
                        ),
                        fillColor: Colors.grey.withAlpha(60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  errorBox(isTitleValid, _titleError),
                  Padding(
                    padding: const EdgeInsets.only(top: CustomSize.defaultPadding * 1.5),
                    child: Text(
                      'Date',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withAlpha(60),
                        ),
                        child: Center(
                          child: Text(
                            '${_yearControllar.toString()} - ${_monthControllar.toString().padLeft(2, '0')} - ${_dayControllar.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          DateTime selectedDate = await pickDate();
                          setState(() {
                            _yearControllar = selectedDate.year;
                            _monthControllar = selectedDate.month;
                            _dayControllar = selectedDate.day;
                          });
                        },
                        icon: Icon(
                          Icons.date_range_outlined,
                          size: 36,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: CustomSize.defaultPadding * 1.5),
                    child: Text(
                      'Time',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withAlpha(60),
                        ),
                        child: Center(
                          child: Text(
                            '${_hourControllar.toString().padLeft(2, '0')} : ${_minuteControllar.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          TimeOfDay selected = await pickTime();
                          setState(() {
                            _hourControllar = selected.hour;
                            _minuteControllar = selected.minute;
                          });
                        },
                        icon: Icon(
                          Icons.watch_later_outlined,
                          size: 36,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  errorBox(isTimeValid, _timeError),
                  SizedBox(height: CustomSize.defaultPadding * 4),
                  InkWell(
                    onTap: () {
                      dateTime = DateTime.now();
                      DateTime selectTime = DateTime(
                        _yearControllar,
                        _monthControllar,
                        _dayControllar,
                        _hourControllar,
                        _minuteControllar,
                      );

                      setState(() {
                        isCategoryValid = (selectedCategory == null) ? false : true;
                        isTitleValid = (_titleControllar.text.isEmpty) ? false : true;
                        isTimeValid = (selectTime.isAfter(dateTime)) ? false : true;
                      });

                      if (isCategoryValid && isTitleValid && isTimeValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Transaction saved'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                          ),
                        );
                        _titleControllar.text = '';
                      }

                      // VALIDATIONS
                      //isCategoryValid
                      //isTitleValid
                      //isTimeValid
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withAlpha(120),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: CustomSize.defaultPadding * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
