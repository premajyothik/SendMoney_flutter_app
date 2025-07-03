import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app/presentation/cubits/transaction_cubit.dart';
import 'package:send_money_app/presentation/data/models/transaction_model.dart';

import '../mocks/mock_api_service.mocks.dart';

void main() {
  late MockApiService mockApi;
  late TransactionCubit cubit;

  setUp(() {
    mockApi = MockApiService();
    cubit = TransactionCubit(mockApi);
  });

  tearDown(() {
    cubit.close();
  });

  group('TransactionCubit', () {
    final fakeTransaction = TransactionModel(
      amount: 100.0,
      date: DateTime.now(),
    );

    blocTest<TransactionCubit, TransactionState>(
      'emits success when sendMoney succeeds',
      build: () {
        when(mockApi.postTransaction(any)).thenAnswer((_) async => true);
        return TransactionCubit(mockApi);
      },
      act: (cubit) => cubit.sendMoney(100.0),
      expect: () => [
        isA<TransactionState>().having((s) => s.status, 'status', 'success'),
      ],
    );

    blocTest<TransactionCubit, TransactionState>(
      'emits error when sendMoney fails',
      build: () {
        when(mockApi.postTransaction(any)).thenAnswer((_) async => false);
        return TransactionCubit(mockApi);
      },
      act: (cubit) => cubit.sendMoney(200.0),
      expect: () => [
        isA<TransactionState>().having((s) => s.status, 'status', 'error'),
      ],
    );

    blocTest<TransactionCubit, TransactionState>(
      'emits state with transactions when fetchTransactions succeeds',
      build: () {
        when(
          mockApi.fetchTransactions(),
        ).thenAnswer((_) async => [fakeTransaction]);
        return TransactionCubit(mockApi);
      },
      act: (cubit) => cubit.loadTransactions(),
      expect: () => [
        isA<TransactionState>().having(
          (s) => s.transactions?.length,
          'transactions.length',
          1,
        ),
      ],
    );

    blocTest<TransactionCubit, TransactionState>(
      'handles empty fetchTransactions',
      build: () {
        when(mockApi.fetchTransactions()).thenAnswer((_) async => []);
        return TransactionCubit(mockApi);
      },
      act: (cubit) => cubit.loadTransactions(),
      expect: () => [
        isA<TransactionState>().having(
          (s) => s.transactions?.length,
          'transactions.length',
          0,
        ),
      ],
    );
  });
}
