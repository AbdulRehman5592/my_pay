import 'package:flutter/material.dart';
import 'package:mypay/commons/amount_input_dialog.dart';

import '../../data/repo/transaction_repo.dart';
import '../../data/repo/transfer_repo.dart';
import '../../data/repo/wallet_repo.dart';
import '../../services/wallet_service.dart';

class UserDashboard extends StatefulWidget {
  final String userId;
  const UserDashboard({super.key, required this.userId});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final walletService = WalletService(
    walletRepo: WalletRepository(),
    txnRepo: TransactionRepository(),
    transferRepo: TransferRepository(),
  );
  String user = '';

  @override
  void initState() {
    super.initState();
    user = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("User Dashboard",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: const [
          Icon(Icons.person_outline, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.person, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(child: Icon(Icons.account_circle, size: 80)),
            ListTile(
                leading: Icon(Icons.wallet), title: Text('Wallet Balance')),
            ListTile(leading: Icon(Icons.menu), title: Text('Menu')),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: Colors.grey[300]),
                const SizedBox(width: 12),
                Text(widget.userId,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const Spacer(),
                _actionButton(
                  "Send Money",
                  Colors.blueAccent,
                  Icon(Icons.send),
                  (amount) =>
                      Future.value(false), // Dummy function for non-transfer
                  isTransfer: true,
                  onTransfer: (amount, recipient) => walletService.sendMoney(
                    senderWalletId: user,
                    receiverWalletId: recipient,
                    amount: amount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                FutureBuilder<double>(
                  future: getbalance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _walletCard('Loading...', 'Rs', Colors.blueAccent);
                    }
                    return _walletCard(
                        '${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                        'Rs',
                        Colors.blueAccent);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Spent",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text("Rs.3141,000",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: 0.1),
                        const SizedBox(height: 4),
                        const Text("10%")
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("Recent Transactions",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _transactionTile(
                        Icons.attach_money, 'Deposit', '2000')),
                const SizedBox(width: 10),
                Expanded(
                    child:
                        _transactionTile(Icons.money_off, 'Withdrawal', '170')),
                const SizedBox(width: 10),
                Expanded(
                    child: _transactionTile(
                        Icons.compare_arrows, 'Transfer', '40')),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Transactions Details",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _detailedTransaction("Withdrawal", "3543,000"),
                  _detailedTransaction("Transfer", "\$200", status: "Pending"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  "Add Funds",
                  Colors.blueAccent,
                  Icon(Icons.add),
                  (amount) => walletService.depositMoney(
                      walletId: user, amount: amount),
                ),
                _actionButton(
                  "Withdraw",
                  Colors.indigo,
                  Icon(Icons.monetization_on),
                  (amount) => walletService.depositMoney(
                      walletId: 'wallet_$user', amount: amount),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<double> getbalance() async {
    final balance = await walletService.getUserBalance(user);
    return balance;
  }

  Widget _walletCard(String amount, String label, Color color) {
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [color.withOpacity(0.7), color]),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Wallet Balance", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(amount,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _transactionTile(IconData icon, String title, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(amount)
        ],
      ),
    );
  }

  Widget _detailedTransaction(String title, String amount,
      {String status = "Completed"}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.black54),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(status,
                  style: TextStyle(
                      color:
                          status == "Pending" ? Colors.orange : Colors.green))
            ],
          )
        ],
      ),
    );
  }

  Widget _actionButton(
    String label,
    Color color,
    Icon icon,
    Future<bool> Function(double amount) onTransaction, {
    bool isTransfer = false,
    Future<bool> Function(double amount, String recipient)? onTransfer,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        iconColor: Colors.white,
        iconAlignment: IconAlignment.end,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        if (isTransfer && onTransfer != null) {
          showAmountInputDialog(
            context: context,
            title: label,
            onConfirmed: (amount) {}, // Dummy function for transfer case
            isTransfer: true,
            onTransferConfirmed: (amount, recipient) async {
              final success = await onTransfer(amount, recipient);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('$label of ¥$amount to $recipient successful')),
                );
                setState(() {}); // Refresh the UI to show updated balance
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transfer failed')),
                );
              }
            },
          );
        } else {
          showAmountInputDialog(
            context: context,
            title: label,
            onConfirmed: (amount) async {
              final success = await onTransaction(amount);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label of ¥$amount successful')),
                );
                setState(() {}); // Refresh the UI to show updated balance
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaction failed')),
                );
              }
            },
          );
        }
      },
      label: Text(label, style: const TextStyle(color: Colors.white)),
      icon: icon,
    );
  }
}
