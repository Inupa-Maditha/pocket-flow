import 'package:flutter/cupertino.dart' as icons;
import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/icons_and_colors.dart';
import 'package:pocket_flow/constants/paddings.dart';
import 'package:pocket_flow/widgets/income_expense_category_card.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class CreateNewCategory extends StatefulWidget {
  final bool isExpense;
  const CreateNewCategory({super.key, required this.isExpense});

  @override
  State<CreateNewCategory> createState() => _CreateNewCategoryState();
}

class _CreateNewCategoryState extends State<CreateNewCategory> {
  TextEditingController categoryNameController = TextEditingController();

  IconData? selectedIcon;
  late String selectedName;
  late Color selectedColor;
  late IconData defaultIcon;
  late Color selectedIconColor;
  late bool isValidCategoryName;
  late List<IconData> customIcons;
  late List<IconData> customIconsHome;

  Future<void> pickColor() async {
    final Color picked = await showColorPickerDialog(
      context,
      selectedColor,
      title: const Text('Select Color'),
      width: 40,
      height: 40,
      spacing: 0,
      runSpacing: 0,
      borderRadius: 20,
      heading: const Text('Select color', style: TextStyle(fontSize: 16)),
      subheading: const Text('Select shade'),
      showColorName: true,
      showColorCode: true,
      colorCodeHasColor: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.wheel: true,
      },
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: true,
        dialogActionButtons: true,
      ),
    );

    setState(() => selectedColor = picked);
  }

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    defaultIcon = Icons.help_outline;
    selectedName = 'Category Name';
    isValidCategoryName = true;
    customIcons = (widget.isExpense)
        ? IconsAndColors.expenseIconList
        : IconsAndColors.incomeIconList;
    customIconsHome = (widget.isExpense)
        ? IconsAndColors.expenseIconListHome
        : IconsAndColors.incomeIconListHome;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Create New Category')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              IncomeExpenseCategoryCard(
                isIncome: !widget.isExpense,
                ammount: 'XXXX',
                transactionCount: 'XX',
                categoryName: selectedName,
                categoryIcon: defaultIcon,
                categoryColor: selectedColor,
              ),
              SizedBox(height: CustomSize.defaultPadding * 2),
              Text(
                'Icon',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Choose an icon for your category',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              SizedBox(height: CustomSize.defaultPadding),
              SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 10,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    if ((index < 9)) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedIcon = customIconsHome[index];
                            defaultIcon = customIconsHome[index];
                          });
                        },
                        icon: Icon(
                          customIconsHome[index],
                          size: 36,
                          color: (selectedIcon != customIconsHome[index])
                              ? Colors.black38
                              : Colors.blueAccent,
                        ),
                      );
                    } else {
                      return IconButton(
                        onPressed: () {
                          selectedIcon = defaultIcon;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return AlertDialog(
                                    title: const Text('Select Icon'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      height: MediaQuery.of(context).size.height * 1 / 3,
                                      child: GridView.builder(
                                        itemCount: customIcons.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 8,
                                              crossAxisSpacing: 8,
                                            ),
                                        itemBuilder: (context, index) {
                                          return IconButton(
                                            onPressed: () {
                                              setDialogState(() {
                                                selectedIcon = customIcons[index];
                                              });
                                            },
                                            icon: Icon(
                                              customIcons[index],
                                              size: 36,
                                              color: (selectedIcon != customIcons[index])
                                                  ? Colors.black38
                                                  : Colors.blueAccent,
                                            ),
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
                                            if (selectedIcon != null) {
                                              defaultIcon = selectedIcon!;
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
                        icon: Icon(
                          icons.CupertinoIcons.ellipsis_circle,
                          size: 36,
                          color: Colors.black,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: CustomSize.defaultPadding),
              Text(
                'Color',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Choose a color for your category',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              SizedBox(height: CustomSize.defaultPadding),
              SizedBox(
                child: GridView.builder(
                  itemCount: 12,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: (deviceWidth - 206) / 15,
                    crossAxisSpacing: (deviceWidth - 206) / 10,
                  ),
                  itemBuilder: (context, index) {
                    if ((index < 11)) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedColor = IconsAndColors.customColorsHome[index];
                          });
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color:
                                  (selectedColor !=
                                      IconsAndColors.customColorsHome[index])
                                  ? Colors.transparent
                                  : Colors.black,
                              width: 3,
                            ),
                          ),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.white, width: 3),
                              color: IconsAndColors.customColorsHome[index],
                            ),
                            child:
                                ((selectedColor !=
                                    IconsAndColors.customColorsHome[index]))
                                ? Icon(Icons.done, color: Colors.transparent)
                                : Icon(Icons.done, color: Colors.black),
                          ),
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          pickColor();
                        },
                        child: Icon(
                          icons.CupertinoIcons.ellipsis_circle,
                          size: 44,
                          color: Colors.black,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: CustomSize.defaultPadding),
              Text(
                'Category Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Enter a name for your category',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              SizedBox(height: CustomSize.defaultPadding),
              SizedBox(
                width: deviceWidth,
                child: TextFormField(
                  controller: categoryNameController,
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
                      'SHORT EATS AND BEVERAGES',
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
              Text(
                'Use only English letters, numbers, spaces, _ and -',
                style: TextStyle(
                  color: (isValidCategoryName) ? Colors.transparent : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: CustomSize.defaultPadding * 2,
                ),
                child: InkWell(
                  onTap: () async {
                    isValidCategoryName = RegExp(
                      r'^[a-zA-Z0-9_ -]+$',
                    ).hasMatch(categoryNameController.text.trim());
                    if (isValidCategoryName) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Transaction saved'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      );
                      selectedName = categoryNameController.text.trim();
                      setState(() {});
                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } else {
                      setState(() {});
                    }
                    // widget.isExpense
                    // selectedColor
                    // defaultIcon
                    // selectedName
                    // isValidCategoryName
                  },
                  child: Container(
                    width: deviceWidth,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: icons.Center(
                      child: Text(
                        'Save ${(widget.isExpense) ? 'Expense' : 'Income'} Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: CustomSize.defaultPadding * 2),
            ],
          ),
        ),
      ),
    );
  }
}
