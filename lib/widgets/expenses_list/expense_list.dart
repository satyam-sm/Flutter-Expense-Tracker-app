import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense_model.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key,
      required this.expenses,
      required this.onRemoveExpense,
      required this.onEditExpense});
  final Function(Expense expense) onRemoveExpense;
  final Function(Expense expense) onEditExpense;

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: ((context, index) => Dismissible(
          key: ValueKey(ExpenseItem(expenses[index])),
          background: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.blue, Colors.red, Colors.red],
                stops: [0.0, 0.47, 0.53, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onRemoveExpense(expenses[index]);
            }
            if (direction == DismissDirection.startToEnd) {
              onEditExpense(expenses[index]);
            }
          },
          child: GestureDetector(
              onLongPress: () {
                onEditExpense(expenses[index]);
              },
              child: ExpenseItem(expenses[index])))),
    );
    //listView builder creates a scrollable list(column) and loads/Creates new children only when it is needed (about to appear in screen) -- do performance optiomisation
  }
}
