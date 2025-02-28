import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { work, leisure, home, food }

const categoryIcons = {
  Category.work: Icons.work,
  Category.leisure: Icons.local_bar,
  Category.home: Icons.home,
  Category.food: Icons.lunch_dining
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allexpenses, this.category)
      : expenses = allexpenses
            .where((expense) => expense.category == category)
            .toList(); //extra utility constructor function

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (Expense expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
