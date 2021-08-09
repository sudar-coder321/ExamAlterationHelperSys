//import 'package:exam_alteration/Screens/Faculty_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:exam_alteration/Screens/loginpage.dart';
import 'package:exam_alteration/Screens/EDS.dart';
import 'package:exam_alteration/Screens/Faculty_page.dart';
import 'package:exam_alteration/graphql/graphql.dart';
import 'package:exam_alteration/graphql/graphqlqueries.dart';
import 'package:exam_alteration/graphql/authentication/auth_graph.dart';
import 'package:exam_alteration/graphql/authentication/token.dart';

class MainTopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
        ),
        tooltip: 'Go Back',
        iconSize: 30,
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar(this.firstName, this.maincontent, this.email, this.phonenumber);
  final firstName;
  final maincontent;
  final email;
  final phonenumber;
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        tooltip: 'Go Back',
        iconSize: 30,
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      title: IconButton(
        icon: Icon(
          Icons.assignment_ind,
        ),
        iconSize: 30,
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => maincontent),
              (Route<dynamic> route) => false);
        },
      ),
      titleSpacing: -10.0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.account_circle_rounded),
          iconSize: 30,
          tooltip: 'Profile Details',
          onPressed: () {
            profilePane(context, firstName, email, phonenumber);
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_rounded),
          iconSize: 30,
          tooltip: 'Notifications',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Notification bar is pressed'),
              duration: const Duration(milliseconds: 1200),
            ));
          },
        ),
      ],
    );
  }
}

class ContactUs extends StatelessWidget {
  ContactUs(this.firstName, this.token);
  final firstName;
  final token;
  final pagestatus = 'grievances';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Column(
            children: [
              Image.asset(
                "images/amrlogo.png",
                width: MediaQuery.of(context).size.width / 10,
                height: MediaQuery.of(context).size.width / 10,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Designed and maintained by',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 60,
                ),
              ),
              Text(
                'Amrita AUMS Team',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 60,
                ),
              ),
            ],
          )),
          Container(
              child: Column(
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 60,
                ),
              ),
              Text(
                '+044-23456789',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 60,
                ),
              ),
              SelectableText(
                'team_aums@cb.amrita.edu',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 60,
                ),
              ),
            ],
          )),
          InkWell(
            child: Text(
              'Raise Complaint',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 75,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Fill in the details',
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomForm(
                            'Enter your grievance here and our technician will get back to you soon ',
                            pagestatus,
                            firstName,
                            token),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class Exam {
  String code;
  String subject;
  String day;
  String date;
  String slot;
  String room;
  String block;
  Exam(
      {@required this.code,
      @required this.subject,
      @required this.day,
      @required this.date,
      @required this.slot,
      @required this.room,
      @required this.block});
}

class Records {
  String examName;
  String examCode;
  String examCourse;
  String examdate;
  String slot;
  String startTime;
  String endTime;
  Records(
      {@required this.examName,
      @required this.examCode,
      @required this.examCourse,
      @required this.examdate,
      @required this.slot,
      @required this.startTime,
      @required this.endTime});
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Copyright',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                SizedBox(width: 3.0),
                Icon(
                  Icons.copyright_rounded,
                  size: 14.0,
                  color: Colors.white60,
                ),
                SizedBox(width: 3.0),
                Text(
                  '2021 Amrita Vishwa Vidyapeetham, Coimbatore.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            Text(
              'All rights reserved',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  CustomForm(
    this.hintText,
    this.pagestatus,
    this.facultyName,
    this.token,
  );
  final token;
  final hintText;
  final pagestatus;
  final facultyName;
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final reasonController = TextEditingController();
  // GraphQLClient _grieve_data = GraphQL().getClient();
  GraphQLClient _grieve;
  GraphQLqueries gq = new GraphQLqueries();
  AuthGraphQL ag = new AuthGraphQL();
  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ag.setAuth(widget.token);
    _grieve = ag.getClient();
  }

  Future<void> collect(reasonController, pagestatus) async {
    print(widget.token);
    print("inside collect");

    if (widget.pagestatus == 'grievances') {
      print(reasonController.text);
      final QueryResult result = await _grieve.queryCharacter(
          gq.createGrievances(widget.facultyName, reasonController.text));
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: reasonController,
          maxLength: TextField.noMaxLength,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 10),
            ),
            hintText: widget.hintText,
          ),
          maxLines: 10,
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
                foregroundColor:
                    MaterialStateColor.resolveWith((Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.white;
                }),
                backgroundColor:
                    MaterialStateColor.resolveWith((Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.blue;
                }),
              ),
              onPressed: () {
                collect(reasonController, widget.pagestatus);
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              SelectableText(
                                  'Your Request has been submitted.'),
                              SizedBox(height: 50),
                              SelectableText(
                                  'Press ok to close the alert dialog'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Text('Submit'),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> profilePane(BuildContext context, String firstName, String email,
    String phonenumber) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, right: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                color: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        radius: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$firstName',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '$email',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '$phonenumber',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, true);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  elevation: 10,
                                  backgroundColor: Colors.transparent,
                                  child: PastRecordFaculty(firstName));
                            },
                          );
                        },
                        child: Text(
                          'Past Records',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      SimpleDialogOption(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (Route<dynamic> route) => true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                              color: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0,
                                      right: 4.0,
                                      top: 4.0,
                                      bottom: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.logout,
                                        ),
                                        iconSize: 20,
                                        onPressed: () {},
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        'Log-out',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  )),
                ),
              ),
            ),
          ),
        );
      });
}

class ReusableCard extends StatelessWidget {
  ReusableCard({this.cardChild, this.onPress});

  final Widget cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 180,
        width: 160,
        child: cardChild,
        margin:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
        decoration: BoxDecoration(
          color: Colors.white54.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
