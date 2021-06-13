import 'package:exam_alteration/graphql/authentication/token.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Screens/loginpage.dart';

void main() => runApp(WebApp());

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Token>(
      create: (context) => Token(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Color(0xF6282525),
          ),
          textTheme: GoogleFonts.tienneTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: LoginScreen(),
        // routes: {
        //   '/': (context) => LoginScreen(),
        // },
      ),
    );
  }
}
