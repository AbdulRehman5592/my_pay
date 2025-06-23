import '../data/models/transaction.dart';
import '../data/models/transfer.dart';
import '../data/repo/transaction_repo.dart';
import '../data/repo/transfer_repo.dart';
import '../data/repo/wallet_repo.dart';

class WalletService {
  final WalletRepository walletRepo;
  final TransactionRepository txnRepo;
  final TransferRepository transferRepo;

  WalletService({
    required this.walletRepo,
    required this.txnRepo,
    required this.transferRepo,
  });

  Future<double> getUserBalance(String userId) async {
    return await walletRepo.getBalance(userId);
  }

  Future<bool> sendMoney({
    required String senderWalletId,
    required String receiverWalletId,
    required double amount,
  }) async {
    // Get sender and receiver wallets
    final senderWallet = await walletRepo.getWalletById(senderWalletId);
    final receiverWallet = await walletRepo.getWalletById(receiverWalletId);

    if (senderWallet == null || receiverWallet == null) return false;
    if (senderWallet.balance < amount) return false;

    final now = DateTime.now().toIso8601String();

    // 1. Create Transaction for sender
    final senderTxn = TransactionModel(
      txnId: 'txn_${DateTime.now().millisecondsSinceEpoch}_send',
      walletId: senderWalletId,
      txnType: 'withdrawal',
      amount: amount,
      status: 'completed',
      description: 'Transfer to ${receiverWalletId}',
      referenceId: receiverWalletId,
      createdAt: now,
    );

    // 2. Create Transaction for receiver
    final receiverTxn = TransactionModel(
      txnId: 'txn_${DateTime.now().millisecondsSinceEpoch}_receive',
      walletId: receiverWalletId,
      txnType: 'deposit',
      amount: amount,
      status: 'completed',
      description: 'Received from ${senderWalletId}',
      referenceId: senderWalletId,
      createdAt: now,
    );

    // 3. Create Transfer record
    final transfer = Transfer(
      transferId: 'transfer_${DateTime.now().millisecondsSinceEpoch}',
      senderWalletId: senderWalletId,
      receiverWalletId: receiverWalletId,
      amount: amount,
      status: 'completed',
      initiatedAt: now,
      completedAt: now,
    );

    // 4. Perform updates (simulate transaction block)
    try {
      await txnRepo.insertTransaction(senderTxn);
      await txnRepo.insertTransaction(receiverTxn);
      await transferRepo.insertTransfer(transfer);
      await walletRepo.updateBalance(
          senderWalletId, senderWallet.balance - amount);
      await walletRepo.updateBalance(
          receiverWalletId, receiverWallet.balance + amount);
      return true;
    } catch (e) {
      print('Error during sendMoney: $e');
      return false;
    }
  }

  Future<bool> depositMoney({
    required String walletId,
    required double amount,
  }) async {
    final now = DateTime.now().toIso8601String();
    final wallet = await walletRepo.getWalletById(walletId);
    // Get the wallet
    final txn = TransactionModel(
      txnId: 'txn_${DateTime.now().millisecondsSinceEpoch}_receive',
      walletId: walletId,
      txnType: 'deposit',
      amount: amount,
      status: 'completed',
      description: 'deposit to ${walletId}',
      referenceId: walletId,
      createdAt: now,
    );
    try {
      await txnRepo.insertTransaction(txn);
      await walletRepo.updateBalance(walletId, (wallet?.balance ?? 0) + amount);

      return true;
    } catch (e) {
      print('Error during depositMoney: $e');
      return false;
    }
  }
}
