import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceState {
  final double balance;
  final bool isVisible;

  BalanceState({required this.balance, required this.isVisible});
}

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit() : super(BalanceState(balance: 1000.00, isVisible: true));

  void toggleVisibility() {
    emit(BalanceState(balance: state.balance, isVisible: !state.isVisible));
  }

  void deduct(double amount) {
    emit(
      BalanceState(balance: state.balance - amount, isVisible: state.isVisible),
    );
  }
}
