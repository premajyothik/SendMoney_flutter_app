class TransactionModel {
  final double amount;
  final DateTime date;

  TransactionModel({required this.amount, required this.date});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.now(), // Since fake API doesn't return timestamps
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'date': date.toIso8601String()};
  }
}
