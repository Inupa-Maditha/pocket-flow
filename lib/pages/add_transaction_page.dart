import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_flow/constants/app_theme.dart';
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
  final _amountControllar = TextEditingController();

  final String _categoryError = 'Please Select category';
  final String _titleError = "Can't be empty";
  final String _amountError = "Invalid amount";
  final String _timeError = 'Invalid Time';

  List<String> incomeCategoryItems = ['Income 1', 'Income 2', 'Income 3'];
  List<String> expenseCategoryItems = ['Expense 1', 'Expense 2', 'Expense 3'];

  late DateTime dateTime;

  late bool isCategoryValid;
  late bool isTitleValid;
  late bool isAmountValid;
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
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding * 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            color: AppColors.border,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: DropdownButtonFormField<String>(
            items: ((isIncome) ? incomeCategoryItems : expenseCategoryItems)
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            decoration: InputDecoration(border: InputBorder.none),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
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
              icon: Icon(Icons.add_circle_outline, size: 28, color: AppColors.primary),
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
    isAmountValid = true;
    isTimeValid = true;
    isExpensePageSelect = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: CustomSize.defaultPadding),
                child: Text(
                  'Create Transaction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(height: CustomSize.defaultPadding),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  children: [
                    Form(
                      key: _globalKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Transaction Type',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(
                            height: 195,
                            child: DefaultTabController(
                              length: 2,
                              child: Scaffold(
                                appBar: AppBar(
                                  bottom: PreferredSize(
                                    preferredSize: const Size.fromHeight(-10),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        border: Border.all(
                                          color: AppColors.border,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(AppRadius.md),
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
                                        labelPadding: EdgeInsets.all(8),
                                        isScrollable: false,
                                        indicatorAnimation: TabIndicatorAnimation.elastic,
                                        tabs: [Text('Expense'), Text('Income')],
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicator: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.md,
                                          ),
                                        ),
                                        labelColor: AppColors.surface,
                                        unselectedLabelColor: AppColors.textSecondary,
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
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
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
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                fillColor: AppColors.surfaceVariant,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppRadius.md),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          errorBox(isTitleValid, _titleError),
                          Text(
                            'Amount (LKR)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _amountControllar,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                enabled: true,
                                filled: true,
                                isDense: true,
                                counterText: '',
                                contentPadding: EdgeInsets.all(CustomSize.defaultPadding),
                                hint: Text(
                                  '4500',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                                fillColor: AppColors.surfaceVariant,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppRadius.md),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          errorBox(isAmountValid, _amountError),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CustomSize.defaultPadding * 1.5,
                            ),
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: max(0.0, MediaQuery.of(context).size.width / 2),
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  color: AppColors.surfaceVariant,
                                  border: Border.all(color: AppColors.border, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    '${_yearControllar.toString()} - ${_monthControllar.toString().padLeft(2, '0')} - ${_dayControllar.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
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
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: CustomSize.defaultPadding * 1.5,
                            ),
                            child: Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  color: AppColors.surfaceVariant,
                                  border: Border.all(color: AppColors.border, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    '${_hourControllar.toString().padLeft(2, '0')} : ${_minuteControllar.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
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
                                  color: AppColors.primary,
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
                                isCategoryValid = (selectedCategory == null)
                                    ? false
                                    : true;
                                isTitleValid = (_titleControllar.text.isEmpty)
                                    ? false
                                    : true;
                                isAmountValid =
                                    (_amountControllar.text.isEmpty &&
                                        !RegExp(
                                          r'^[0-9]+$',
                                        ).hasMatch(_amountControllar.text))
                                    ? false
                                    : true;
                                isTimeValid = (selectTime.isAfter(dateTime))
                                    ? false
                                    : true;
                              });

                              if (isCategoryValid &&
                                  isTitleValid &&
                                  isTimeValid &&
                                  isAmountValid) {
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
                                _amountControllar.text = '';
                              }

                              // VALIDATIONS
                              //isCategoryValid
                              //isTitleValid
                              //isTimeValid
                            },
                            child: Container(
                              height: 54,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                border: Border.all(color: AppColors.border, width: 1),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.surface,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
