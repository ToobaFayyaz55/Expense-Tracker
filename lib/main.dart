import 'package:flutter/material.dart';

void main() => runApp(ExpenseTrackerApp());

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Expense Tracker',
      home: ExpenseHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final List<Map<String, dynamic>> _expenses = [
    {"title": "Groceries", "amount": 1500.0, "categoryIcon": Icons.shopping_cart},
    {"title": "Rent", "amount": 1000.0, "categoryIcon": Icons.home},
    {"title": "Food", "amount": 600.0, "categoryIcon": Icons.fastfood},
    {"title": "Transport", "amount": 250.0, "categoryIcon": Icons.directions_car},
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  IconData? _selectedCategoryIcon;

  double get _totalSpent {
    return _expenses.fold(0.0, (sum, item) => sum + item['amount']);
  }

  void _addExpense() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty || _selectedCategoryIcon == null) return;

    setState(() {
      _expenses.add({
        "title": _titleController.text,
        "amount": double.parse(_amountController.text),
        "categoryIcon": _selectedCategoryIcon,
      });
    });

    _titleController.clear();
    _amountController.clear();
    _selectedCategoryIcon = null;
    Navigator.pop(context);
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: _amountController, decoration: InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
            DropdownButtonFormField<IconData>(
              decoration: InputDecoration(labelText: "Category"),
              value: _selectedCategoryIcon,
              items: [
                DropdownMenuItem(value: Icons.shopping_cart, child: Row(children: [Icon(Icons.shopping_cart), SizedBox(width: 8), Text("Groceries")])),
                DropdownMenuItem(value: Icons.home, child: Row(children: [Icon(Icons.home), SizedBox(width: 8), Text("Rent")])),
                DropdownMenuItem(value: Icons.fastfood, child: Row(children: [Icon(Icons.fastfood), SizedBox(width: 8), Text("Food")])),
                DropdownMenuItem(value: Icons.directions_car, child: Row(children: [Icon(Icons.directions_car), SizedBox(width: 8), Text("Transport")])),
                // Add more categories as needed
              ],
              onChanged: (IconData? newValue) {
                setState(() {
                  _selectedCategoryIcon = newValue;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(onPressed: _addExpense, child: Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Expense Tracker"),
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            color: Theme.of(context).primaryColor,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Spent",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Rs. ${_totalSpent.toStringAsFixed(0)}",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Expenses",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: _expenses.isEmpty
                ? Center(
                    child: Text(
                      "No expenses added yet!",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _expenses.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _expenses[i]['categoryIcon'],
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          title: Text(
                            _expenses[i]['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            "Rs. ${_expenses[i]['amount'].toStringAsFixed(0)}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        label: Text("Add Expense"),
        icon: Icon(Icons.add),
      ),
    );
  }
}