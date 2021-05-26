import 'package:bithabit/providers/goals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/config.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'providers/auth.dart';

void main() {
  const config = Config(
    apiKey: 'AIzaSyAeWmG96EFgGAla6otWEAI0O9buPPnwU_g',
    databaseUrl:
        'https://habitat-708dd-default-rtdb.europe-west1.firebasedatabase.app',
  );

  runApp(const BithabitApp(config: config));
}

class BithabitApp extends StatelessWidget {
  final Config config;

  const BithabitApp({Key? key, required this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth(config)),
        ChangeNotifierProxyProvider<Auth, Goals>(
          create: (context) => Goals(auth: Auth(config)),
          update: (_, auth, goals) => (goals ?? Goals(auth: auth))..auth = auth,
        ),
      ],
      child: MaterialApp(
        title: 'Bithabit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          errorColor: Colors.red,
          fontFamily: 'OpenSans',
        ),
        home: Consumer<Auth>(
          builder: (ctx, authData, _) {
            return authData.isAuth
                ? HomePage()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) {
                      return authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Scaffold()
                          : AuthPage();
                    },
                  );
          },
        ),
      ),
    );
  }
}
