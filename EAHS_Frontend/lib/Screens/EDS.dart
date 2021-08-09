import 'package:exam_alteration/graphql/authentication/auth_graph.dart';
import 'package:exam_alteration/graphql/authentication/token.dart';
import 'package:exam_alteration/graphql/graphql.dart';
import 'package:exam_alteration/graphql/graphqlqueries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:exam_alteration/common.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class EDSScreen extends StatelessWidget {
  EDSScreen(this.edsname, this.phonenumber, this.email);
  final edsname;
  final phonenumber;
  final email;
  @override
  Widget build(BuildContext context) {
    return ExamDutyStaff(
      maincontent: EDSScreen(edsname, email, phonenumber),
      centercontent: Text('123'),
      edsname: edsname,
      email: email,
      phonenumber: phonenumber,
    );
  }
}

// ignore: must_be_immutable

// ignore: must_be_immutable
class PastRecordEDS extends StatelessWidget {
  PastRecordEDS(
      {@required this.edsname,
      @required this.centercontent,
      @required this.maincontent,
      @required this.email,
      @required this.phonenumber,
      this.onPointerHover});
  final edsname;
  var email;
  var phonenumber;
  final centercontent;
  final maincontent;
  final PointerHoverEventListener onPointerHover;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: TopBar(edsname, maincontent, phonenumber,
                email), // Change to App(widget.facultyname, widget.maincontent)
            body: Center(
              child: Card(
                color: Colors.transparent,
                elevation: 13.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xCFC8C8C8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Faculty Name',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Exam Name',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Exam Date',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Exam Subject',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Slot timings',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Sarah')),
                            DataCell(Text('19')),
                            DataCell(Text('Student')),
                            DataCell(Text('Sarah')),
                            DataCell(Text('19')),
                            DataCell(Text('Student')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Janine')),
                            DataCell(Text('43')),
                            DataCell(Text('Professor')),
                            DataCell(Text('Janine')),
                            DataCell(Text('43')),
                            DataCell(Text('Professor')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('William')),
                            DataCell(Text('27')),
                            DataCell(Text('Associate Professor')),
                            DataCell(Text('William')),
                            DataCell(Text('27')),
                            DataCell(Text('Associate Professor')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EDSContactUS extends StatelessWidget {
  EDSContactUS(
      {@required this.edsname,
      @required this.centercontent,
      @required this.maincontent,
      @required this.phonenumber,
      @required this.email,
      this.token});
  final edsname;
  final email;
  final token;
  final phonenumber;
  final centercontent;
  final maincontent;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("images/background1.jpg"),
        fit: BoxFit.cover,
      )),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TopBar(edsname, maincontent, phonenumber, email),
          body: Stack(
            children: [
              Positioned(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xCFC4C4C4),
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: centercontent,
                  ),
                ),
              ),
              Positioned(
                child: Footer(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EDSContactUS(
                        maincontent: EDSScreen(edsname, phonenumber, email),
                        centercontent: ContactUs(edsname, token),
                        edsname: this.edsname,
                        email: this.email,
                        phonenumber: this.phonenumber);
                  },
                ),
              );
            },
            child: Icon(Icons.help_sharp),
            tooltip: 'Contact-Us',
          ),
        ),
      ),
    );
  }
}

class ExamDutyStaff extends StatefulWidget {
  ExamDutyStaff(
      {@required this.edsname,
      @required this.centercontent,
      @required this.maincontent,
      @required this.email,
      @required this.phonenumber,
      this.onPointerHover,
      this.token});
  final edsname;
  var email;
  var phonenumber;
  final centercontent;
  final token;
  final maincontent;
  final PointerHoverEventListener onPointerHover;
  @override
  _ExamDutyStaffState createState() => _ExamDutyStaffState();
}

class _ExamDutyStaffState extends State<ExamDutyStaff> {
  _ExamDutyStaffState();
  GraphQLClient _countdata = GraphQL().getClient();
  GraphQLqueries gq = new GraphQLqueries();
  AuthGraphQL ag = new AuthGraphQL();
  @override
  void initState() {
    super.initState();
    ag = new AuthGraphQL();
    ag.setAuth(Provider.of<Token>(context, listen: false).getToken());
    _countdata = ag.getClient();
    getCount();
  }

  void getCount() async {
    print("inside count");
    final QueryResult _examdetails =
        await _countdata.queryA(gq.fetchExamDetails());
  }

  //ag.setAuth(Provider.of<Token>(context, listen: false).getToken());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("images/background1.jpg"),
        fit: BoxFit.cover,
      )),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TopBar(widget.edsname, widget.maincontent, widget.phonenumber,
              widget.email),
          body: Stack(
            children: [
              Positioned(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20.0, bottom: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ReusableCard(
                                onPress: () {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Details'),
                                          content: Text(
                                              'Displays the count of total number of exams allocated'),
                                        );
                                      });
                                },
                                cardChild: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Selectable
                                    SelectableText(
                                      'No of Exams',
                                    ),
                                    SelectableText(
                                      '13',
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: ReusableCard(
                                onPress: () {},
                                cardChild: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No of Faculty available',
                                    ),
                                    Text(
                                      '25',
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: ReusableCard(
                                onPress: () {},
                                cardChild: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Faculty not available',
                                    ),
                                    Text(
                                      '8',
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: ReusableCard(
                                onPress: () {},
                                cardChild: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Alternate Faculty available',
                                    ),
                                    Text('5'),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ReusableCard(
                              onPress: () {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text('123'),
                                      );
                                    });
                              },
                              cardChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Exam Slot allocated',
                                  ),
                                  Text('13'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              onPress: () {},
                              cardChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Rooms Available'),
                                  Text('15'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              onPress: () {},
                              cardChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Rooms not used'),
                                  Text('2'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              onPress: () {},
                              cardChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('Slots Altered'), Text('2')],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ReusableCard(
                              onPress: () {},
                              cardChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add/Remove ExamSlot',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              onPress: () {},
                              cardChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Edit Exam Slot Details'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              onPress: () {},
                              cardChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Reschedule Exam'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Footer(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EDSContactUS(
                      maincontent: EDSScreen(
                          widget.edsname, widget.email, widget.phonenumber),
                      centercontent: ContactUs(widget.edsname, widget.token),
                      edsname: widget.edsname,
                      phonenumber: widget.phonenumber,
                      email: widget.email,
                    );
                    // email: email,
                    // phonenumber: phonenumber);
                  },
                ),
              );
            },
            child: Icon(Icons.help_sharp),
            tooltip: 'Contact-Us',
          ),
        ),
      ),
    );
  }
}
