import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/balance_cubit.dart';
import 'send_money_screen.dart';
import 'transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallet")),
      body: Center(
        child: BlocBuilder<BalanceCubit, BalanceState>(
          builder: (context, state) {
            return Column(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Wallet Balance"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.isVisible ? "${state.balance} PHP" : "******"),
                    IconButton(
                      icon: Icon(
                        state.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          context.read<BalanceCubit>().toggleVisibility(),
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text("Send Money"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SendMoneyScreen()),
                  ),
                ),
                ElevatedButton(
                  child: Text("View Transactions"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TransactionScreen()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
