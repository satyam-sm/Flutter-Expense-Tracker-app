import 'dart:io';

import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.onAddExpense, {super.key});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  //alternate method for BELOW to storing input at everychange
  // var _enteredTitle = '';
  // void _saveTitleInput(String inputvalue) {
  //   _enteredTitle = inputvalue;
  //}
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  Category selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void presentDatePicker() {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    showDatePicker(
            context: context,
            firstDate: firstDate,
            lastDate: now,
            initialDate: now)
        .then((value) {
      setState(() {
        _selectedDate = value!;
      });
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid Title, Amount and Date was entered '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'Okay',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                  'Please make sure a valid Title, Amount and Date was entered ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Okay',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ))
                ],
              )); //builder always take a function which  takes context value and returns a widget
    }
  }

  // ----- alternate method for above use sync and await to wait unltil date is selected
//  void presentDatePickerr()  async {
//     final now = DateTime.now();
//     final firstDate = DateTime(now.year - 1, now.month, now.day);
//     final pickedDate = await showDatePicker(
//             context: context,
//             firstDate: firstDate,
//             lastDate: now,
//             initialDate: now,);
//   }
//   setState(() {
//     selectedDate = pickedDate ;
//   });
  //-----
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      ///  checks for error
      _showDialog();

      return; //after return arrived all code below this in this file will not execute
    }
    //to add new expense on submit

    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: double.tryParse(_amountController.text) as double,
        date: _selectedDate as DateTime,
        category: selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context)
        .viewInsets
        .bottom; //to find remaining space after keyboard is opened

//layout builder is another approach to mediaquery , where we can get available width, height according to the constraints set by parent widget to this widget(builder widget) and design content accordingly

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        width: width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, keyboardSpace + 16),
            child: Column(
              children: [
                const Text(
                  'Create new Expense',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                // these if else without curly braces is used for list of widget type content seperated by coma
                if (width > 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          // maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    // ALTERNATE METHOD onChanged: _saveTitleInput, on every press of keyboard button this function gets triggered
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Title')),
                  ),
                if (width > 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : formatter.format(_selectedDate!),
                        style: const TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        style: const ButtonStyle(
                            iconSize: WidgetStatePropertyAll(30)),
                        onPressed: presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          // maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No Date Chosen'
                                  : formatter.format(_selectedDate!),
                              style: const TextStyle(fontSize: 15),
                            ),
                            IconButton(
                                style: const ButtonStyle(
                                    iconSize: WidgetStatePropertyAll(30)),
                                onPressed: presentDatePicker,
                                icon: const Icon(Icons.calendar_month)),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (width < 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
