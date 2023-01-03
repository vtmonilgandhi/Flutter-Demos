import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final Function addTx;
  NewTransaction({super.key, required this.addTx});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        // margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
              // onChanged: (val) => titleInput = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: amountController,
              // onChanged: (val) => amountInput = val,
            ),
            TextButton(
              onPressed: () {
                addTx(
                    titleController.text, double.parse(amountController.text));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
