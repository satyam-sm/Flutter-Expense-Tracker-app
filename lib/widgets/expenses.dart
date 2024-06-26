import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/edit_expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses(this.isDarkMode, {super.key});
  final ThemeMode isDarkMode;
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 14.45,
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(addExpense),
    );
  }

//function to add new expense , this function is to be sent on new_expense dart
  void addExpense(Expense expenseItem) {
    setState(() {
      _registeredExpenses.add(expenseItem);
    });
    Navigator.pop(context);
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense Deleted.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  int editExpenseIndex = 0;
  void editExpense(Expense expenseItem) {
    editExpenseIndex = _registeredExpenses.indexOf(expenseItem);
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => EditExpense(
        returnEditExpense,
        cancelEditReq,
        expenseTitle: expenseItem.title,
        expenseAmount: expenseItem.amount,
        expenseCategory: expenseItem.category,
        expenseDate: expenseItem.date,
      ),
    );
  }

  void cancelEditReq() {
    setState(() {});
  }

  void returnEditExpense(
    Expense expenseItem,
  ) {
    setState(() {
      _registeredExpenses.removeAt(editExpenseIndex);
    });
    setState(() {
      _registeredExpenses.insert(editExpenseIndex, expenseItem);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Container(
            padding: const EdgeInsets.all(9.0),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.8)
                  : Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8), // Background color of the circle
              shape: BoxShape.circle,
            ),
            child: Text(
              _registeredExpenses.length.toString(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onPrimaryContainer
                  // Text color
                  ),
            ),
          ),
        ),
        title: const Center(child: Text('Flutter Expense Tracker')),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                    //to move list content out of list as ExpenseList gives a List but we want comma seperated widgets
                    child: _registeredExpenses.isEmpty
                        ? const Center(
                            child: Text(
                            'No Expenses found. Try adding some',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))
                        : ExpenseList(
                            expenses: _registeredExpenses,
                            onRemoveExpense: removeExpense,
                            onEditExpense: editExpense,
                          ))
              ],
            )
          : Row(
              children: [
                Expanded(
                    child: Chart(
                        expenses:
                            _registeredExpenses)), // expanded limits the size of its child to available size after allocating other items. --- it is used

                Expanded(
                    //to move list content out of list as ExpenseList gives a List but we want comma seperated widgets
                    child: _registeredExpenses.isEmpty
                        ? const Center(
                            child: Text(
                            'No Expenses found. Try adding some',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))
                        : ExpenseList(
                            expenses: _registeredExpenses,
                            onRemoveExpense: removeExpense,
                            onEditExpense: editExpense,
                          ))
              ],
            ),
    );
  }
}
