import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/cubits/balance_cubit.dart';
import 'presentation/cubits/transaction_cubit.dart';
import 'presentation/data/data_sources/api_service.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiService = ApiService();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BalanceCubit()),
        BlocProvider(create: (_) => TransactionCubit(apiService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Send Money App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
