import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/data_sources/api_service.dart';
import '../data/models/transaction_model.dart';

class TransactionState {
  final String status;
  final List<TransactionModel>? transactions;
  final String? error;

  TransactionState({required this.status, this.transactions, this.error});

  factory TransactionState.initial() => TransactionState(status: 'idle');

  TransactionState copyWith({
    String? status,
    List<TransactionModel>? transactions,
    String? error,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionState &&
          status == other.status &&
          transactions == other.transactions &&
          error == other.error;

  @override
  int get hashCode =>
      status.hashCode ^ (transactions?.hashCode ?? 0) ^ (error?.hashCode ?? 0);
}

class TransactionCubit extends Cubit<TransactionState> {
  final ApiService api;

  TransactionCubit(this.api)
    : super(TransactionState(transactions: [], status: 'idle'));

  Future<void> sendMoney(double amount) async {
    final tx = TransactionModel(amount: amount, date: DateTime.now());
    final success = await api.postTransaction(tx);

    // ignore: unnecessary_null_comparison
    if (success == true) {
      final updated = List<TransactionModel>.from(state.transactions ?? [])
        ..add(tx);
      emit(TransactionState(transactions: updated, status: 'success'));
    } else {
      emit(TransactionState(transactions: state.transactions, status: 'error'));
    }
  }

  void clearStatus() {
    emit(TransactionState(transactions: state.transactions, status: ''));
  }

  Future<void> loadTransactions() async {
    final fetched = await api.fetchTransactions();
    emit(TransactionState(transactions: fetched, status: 'loaded'));
  }
}
