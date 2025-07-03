import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/balance_cubit.dart';
import '../cubits/transaction_cubit.dart';

class SendMoneyScreen extends StatefulWidget {
  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final amount = double.tryParse(_controller.text);
    if (amount == null || amount <= 0) {
      _showBottomSheet("Invalid amount");
      return;
    }

    final balance = context.read<BalanceCubit>().state.balance;
    if (amount > balance) {
      _showBottomSheet("Insufficient balance");
      return;
    }

    context.read<TransactionCubit>().sendMoney(amount);
    context.read<BalanceCubit>().deduct(amount);
  }

  void _showBottomSheet(String message) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        height: 120,
        child: Center(child: Text(message)),
      ),
    ).whenComplete(
      Navigator.of(
        context,
      ).pop, // Close the bottom sheet after showing the message
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Money")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {
            if (state.status == 'success') {
              _showBottomSheet("Transaction Successful");
              context.read<TransactionCubit>().clearStatus();
            } else if (state.status == 'error') {
              _showBottomSheet("Transaction Failed");
              context.read<TransactionCubit>().clearStatus();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Enter amount"),
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: Text("Submit")),
              ],
            );
          },
        ),
      ),
    );
  }
}
