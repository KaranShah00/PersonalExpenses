import 'package:flutter/material.dart';
import 'package:personalexpenses/providers/groups.dart';

import 'package:provider/provider.dart';

import './screens/expenses_screen.dart';
import './providers/transactions.dart';
import './providers/shopping.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized(); // ensures device cant be rotated
//  SystemChrome.setPreferredOrientations([         to landscape mode
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Transactions(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Shopping(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Groups(),
        )
      ],
      child: MaterialApp(
        title: 'Personal Expenses',
        home: ExpensesScreen(),
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
