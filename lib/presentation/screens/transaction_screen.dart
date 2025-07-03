import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubits/transaction_cubit.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    // Load transactions when the screen is first shown
    context.read<TransactionCubit>().loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction History")),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          final transactions = state.transactions;

          if (transactions?.isEmpty == true) {
            return Center(child: Text("No transactions found."));
          }

          return ListView.builder(
            itemCount: transactions?.length,
            itemBuilder: (context, index) {
              final tx = transactions?[index];
              final formattedDate = DateFormat(
                'yyyy-MM-dd HH:mm:ss',
              ).format(tx?.date ?? DateTime.now());

              return ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text("Sent: ₱${tx?.amount.toStringAsFixed(2)}"),
                subtitle: Text(formattedDate),
              );
            },
          );
        },
      ),
    );
  }
}
