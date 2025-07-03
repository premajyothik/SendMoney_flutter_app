import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';

class ApiService {
  final _apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Local memory store for fallback
  final List<TransactionModel> _localTransactions = [];

  /// Simulates POST request to fake API or stores locally on error
  Future<bool?> postTransaction(TransactionModel? transaction) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction?.toJson()),
      );

      if (response.statusCode == 201) {
        _localTransactions.add(transaction!);
        return true;
      } else {
        throw Exception('Fake API failed');
      }
    } catch (e) {
      // Fallback: Store locally
      print('POST failed. Using fallback. Reason: $e');
      return false; // Simulate success
    }
  }

  /// Simulates GET request or returns locally stored data
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.take(5).map((item) {
          return TransactionModel(
            amount: (item['id'] as int).toDouble() * 10,
            date: DateTime.now().subtract(Duration(days: item['id'])),
          );
        }).toList();
      } else {
        throw Exception('GET failed');
      }
    } catch (e) {
      print('GET failed. Using fallback. Reason: $e');
      return _localTransactions;
    }
  }
}
