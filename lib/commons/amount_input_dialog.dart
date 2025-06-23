import 'package:flutter/material.dart';

Future<void> showAmountInputDialog({
  required BuildContext context,
  required String title,
  required Function(double amount) onConfirmed,
  bool isTransfer = false,
  Function(double amount, String recipient)? onTransferConfirmed,
}) async {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            if (isTransfer) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  labelText: 'Recipient Wallet ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final input = _amountController.text.trim();
              final amount = double.tryParse(input);

              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid amount')),
                );
                return;
              }

              if (isTransfer) {
                final recipient = _recipientController.text.trim();
                if (recipient.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter recipient wallet ID')),
                  );
                  return;
                }
                Navigator.pop(context);
                onTransferConfirmed?.call(amount, recipient);
              } else {
                Navigator.pop(context);
                onConfirmed(amount);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
