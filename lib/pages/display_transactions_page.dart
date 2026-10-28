import 'package:flutter/material.dart';
import 'package:pocket_flow/constants/paddings.dart';

class DisplayTransactionsPage extends StatefulWidget {
  const DisplayTransactionsPage({super.key});

  @override
  State<DisplayTransactionsPage> createState() => _DisplayTransactionsPageState();
}

class _DisplayTransactionsPageState extends State<DisplayTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: CustomSize.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'View and manage your income and expenses',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
