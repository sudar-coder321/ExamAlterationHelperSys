import 'package:exam_alteration/graphql/authentication/auth_graph.dart';
import 'package:exam_alteration/graphql/graphql.dart';
import 'package:exam_alteration/graphql/graphqlqueries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:ui';
import 'package:exam_alteration/common.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// class SQLiteDbProvider {
//    SQLiteDbProvider._();
//    static final SQLiteDbProvider db = SQLiteDbProvider._();
//    static Database _database;

//    Future<Database> get database async {
//       if (_database != null)
//       return _database;
//       _database = await initDB();
//       return _database;
//    }
//    initDB() async {
//       Directory documentsDirectory = await
//       getApplicationDocumentsDirectory();
//       String path = join(documentsDirectory.path, "ProductDB.db");
//       return await openDatabase(
//          path, version: 1,
//          onOpen: (db) {},
//          onCreate: (Database db, int version) async {
//             await db.execute(
//                "CREATE TABLE Product ("
//                "id INTEGER PRIMARY KEY,"
//                "name TEXT,"
//                "description TEXT,"
//                "price INTEGER,"
//                "image TEXT"")"
//             );
//             await db.execute(
//                "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
//                values (?, ?, ?, ?, ?)",
//                [1, "iPhone", "iPhone is the stylist phone ever", 1000, "iphone.png"]
//             );
//             await db.execute(
//                "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
//                values (?, ?, ?, ?, ?)",
//                [2, "Pixel", "Pixel is the most feature phone ever", 800, "pixel.png"]
//             );
//             await db.execute(
//                "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
//                values (?, ?, ?, ?, ?)",
//                [3, "Laptop", "Laptop is most productive development tool", 2000, "laptop.png"]
//             );
//             await db.execute(
//                "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
//                values (?, ?, ?, ?, ?)",
//                [4, "Tablet", "Laptop is most productive development tool", 1500, "tablet.png"]
//             );
//             await db.execute(
//                "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
//                values (?, ?, ?, ?, ?)",
//                [5, "Pendrive", "Pendrive is useful storage medium", 100, "pendrive.png"]
//             );
//             await db.execute(
//                "INSERT INTO Product ('id', 'name', 'description', 'price', 'image')
//                values (?, ?, ?, ?, ?)",
//                [6, "Floppy Drive", "Floppy drive is useful rescue storage medium", 20, "floppy.png"]
//             );
//          }
//       );
//    }
//    Future<List<Product>> getAllProducts() async {
//       final db = await database;
//       List<Map> results = await db.query(
//          "Product", columns: Product.columns, orderBy: "id ASC"
//       );
//       List<Product> products = new List();
//       results.forEach((result) {
//          Product product = Product.fromMap(result);
//          products.add(product);
//       });
//       return products;
//    }
//    Future<Product> getProductById(int id) async {
//       final db = await database;
//       var result = await db.query("Product", where: "id = ", whereArgs: [id]);
//       return result.isNotEmpty ? Product.fromMap(result.first) : Null;
//    }

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainTopBar(),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("images/Login_background.jpg"),
            fit: BoxFit.cover,
          )),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Container(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0),
                    ),
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("images/forgotpasswd.jpg"),
                              fit: BoxFit.cover,
                            )),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0,
                                    right: 4.0,
                                    top: 30.0,
                                    bottom: 0.0),
                                child: Image.asset(
                                  "images/logo.jpg",
                                  width: MediaQuery.of(context).size.width / 10,
                                  height:
                                      MediaQuery.of(context).size.width / 10,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0,
                                    right: 4.0,
                                    top: 0.0,
                                    bottom: 0.0),

                                //children
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width / 150,
                              ),
                              ForgotPasswordForm(),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  String _email = "";
  bool inuser = true;
  GraphQLClient _data = GraphQL().getClient();
  GraphQLqueries gq = new GraphQLqueries();
  AuthGraphQL _ag;

  void _checkemail() async {
    print("inside check email");
    if (_formKey.currentState.validate()) {
      print("Inside formkey validate");

      final QueryResult result = await _data.queryCharacter(gq.getUserEmails());
      print("result is" + result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return new Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AnimatedProgressIndicator(value: _formProgress),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 18,
            ),
            child: TextFormField(
              controller: emailTextController,
              decoration: InputDecoration(
                labelText: 'Enter your Registered Email Address',
              ),
              validator: (username) {
                Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                RegExp regex = new RegExp(pattern);
                if (username == '') return null;
                if (!regex.hasMatch(username) | !inuser) {
                  return 'Invalid username';
                } else
                  return null;
              },
              onChanged: (value) => _email = value,
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 4.0, bottom: 4.0),
            child: SizedBox(
              width: 100,
              height: 40,
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  )),
                  foregroundColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Colors.white;
                  }),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Colors.blue;
                  }),
                ),
                // onPressed: _formProgress == 1.33 ? _validate : null,
                onPressed: _checkemail,
                child: Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
