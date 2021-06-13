import 'package:exam_alteration/graphql/authentication/auth_graph.dart';
import 'package:exam_alteration/graphql/authentication/token.dart';
import 'package:exam_alteration/graphql/graphqlqueries.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'package:exam_alteration/common.dart';

class FacultyScreen extends StatelessWidget {
  FacultyScreen(this.firstName, this.email, this.phonenumber);
  final firstName;
  final email;
  final phonenumber;
  @override
  Widget build(BuildContext context) {
    return Facultydesign(
        facultyname: firstName,
        maincontent: FacultyScreen(firstName, email, phonenumber),
        centercontent: ExamSummary(firstName),
        email: this.email,
        phonenumber: this.phonenumber);
  }
}

class Facultydesign extends StatelessWidget {
  Facultydesign({
    @required this.facultyname,
    @required this.centercontent,
    @required this.phonenumber,
    @required this.email,
    @required this.maincontent,
    this.token,
  });
  final facultyname;
  final phonenumber;
  final email;
  final token;
  final centercontent;
  final maincontent;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("images/background.jpg"),
        fit: BoxFit.cover,
      )),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TopBar(facultyname, maincontent, phonenumber, email),
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
                    return Facultydesign(
                        maincontent:
                            FacultyScreen(facultyname, email, phonenumber),
                        centercontent: ContactUs(facultyname, token),
                        facultyname: facultyname,
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

class ExamSummary extends StatefulWidget {
  ExamSummary(this.facultyname);
  final facultyname;
  @override
  _ExamSummaryState createState() => _ExamSummaryState();
}

class _ExamSummaryState extends State<ExamSummary> {
  List<Widget> _subjects = [];
  AuthGraphQL ag;
  GraphQLqueries gq = new GraphQLqueries();
  GraphQLClient _exam;

  @override
  void initState() {
    super.initState();
    ag = new AuthGraphQL();
    ag.setAuth(Provider.of<Token>(context, listen: false).getToken());
    _exam = ag.getClient();
    getExam();
  }

  void getExam() async {
    final QueryResult _examdetails = await _exam.queryA(gq.fetchExamDetails());
    var temp = _examdetails.data['me']['userT']['takers'];
    for (int i = 0; i < temp.length; i++) {
      Addexam(Exam(
        code: temp[i]['exam']['course']['CourseId'],
        subject: temp[i]['exam']['course']['CourseName'],
        day: temp[i]['exam']['exam']['day'],
        date: temp[i]['exam']['exam']['Date'],
        slot: temp[i]['exam']['exam']['slot'].toString(),
        room: temp[i]['exam']['room']['RoomId'],
        block: temp[i]['exam']['room']['Block'],
      ));
    }
  }

  // ignore: non_constant_identifier_names
  void Addexam(Exam exam) {
    setState(() {
      _subjects.add(
        SubjectDetails(widget.facultyname, exam),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome ${widget.facultyname}',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 60,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'This is your upcoming exam schedule',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 60,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _subjects,
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SubjectDetails extends StatelessWidget {
  SubjectDetails(this.facultyname, this.exam);
  final facultyname;
  var phonenumber;
  var email;
  final Exam exam;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ExamDetailsSummary(exam),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Facultydesign(
                  maincontent: FacultyScreen(facultyname, email, phonenumber),
                  centercontent: ExamDetails(facultyname, exam),
                  facultyname: facultyname,
                  email: this.email,
                  phonenumber: this.phonenumber);
            },
          ),
        );
      },
    );
  }
}

class ExamDetailsSummary extends StatelessWidget {
  ExamDetailsSummary(this.exam);
  final Exam exam;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.panorama_fish_eye_rounded,
          size: MediaQuery.of(context).size.width / 10,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          exam.code,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 70,
          ),
        ),
        Text(
          exam.subject,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 70,
          ),
        ),
        Text(
          exam.day,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 70,
          ),
        ),
        Text(
          exam.date,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width / 70,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ExamDetails extends StatelessWidget {
  ExamDetails(this.facultyname, this.exam);
  final Exam exam;
  var email;
  var phonenumber;
  final facultyname;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        top: 25.0,
        bottom: 25.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.panorama_fish_eye_rounded,
                size: MediaQuery.of(context).size.width / 5,
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                child: Text(
                  'Unable to attend',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 85,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Facultydesign(
                      maincontent:
                          FacultyScreen(facultyname, phonenumber, email),
                      centercontent: ReasonPage(
                        exam,
                        facultyname,
                      ),
                      facultyname: this.facultyname,
                      email: this.email,
                      phonenumber: this.phonenumber,
                    );
                  }));
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  exam.code,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 50,
                  ),
                ),
                Text(
                  exam.subject,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 50,
                  ),
                ),
                Text(
                  exam.day,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 50,
                  ),
                ),
                Text(
                  exam.date,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 50,
                  ),
                ),
                Text(
                  exam.slot,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 50,
                  ),
                ),
                Text(
                  exam.room,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 50,
                  ),
                ),
                Text(
                  exam.block,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 50,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//this.onPointerHover

class ReasonPage extends StatelessWidget {
  ReasonPage(this.exam, this.firstName);
  final Exam exam;
  final firstName;
  final pagestatus = 'faculty_reason';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 25.0, right: 25.0, top: 25.0, bottom: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exam.code,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 55,
                      ),
                    ),
                    Text(
                      exam.date,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 55,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exam.day,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 55,
                      ),
                    ),
                    Text(
                      exam.slot,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 55,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          CustomForm('Enter your reason for shifting the slot here', pagestatus,
              firstName, Provider.of<Token>(context, listen: false).getToken()),
        ],
      ),
    );
  }
}

// class PastRecord extends StatelessWidget {}

class PastRecordFaculty extends StatefulWidget {
  PastRecordFaculty(this.facultyName);
  final facultyName;

  @override
  _PastRecordFacultyState createState() => _PastRecordFacultyState();
}

class _PastRecordFacultyState extends State<PastRecordFaculty> {
  List<DataRow> _records = [];

  AuthGraphQL ag;

  GraphQLqueries gq = new GraphQLqueries();

  GraphQLClient _record;

  @override
  void initState() {
    super.initState();
    ag = new AuthGraphQL();
    ag.setAuth(Provider.of<Token>(context, listen: false).getToken());
    _record = ag.getClient();
    getRecords();
  }

  void getRecords() async {
    final QueryResult _recorddetails =
        await _record.queryA(gq.fetchPastRecords());
    var temp = _recorddetails.data['me']['userT']['takers'];
    for (int i = 0; i < temp.length; i++) {
      print(temp[i]['exam']['exam']['Date']);
      AddRecords(Records(
        examName: temp[i]['exam']['exam']['examName'],
        examCode: temp[i]['exam']['course']['CourseId'],
        examCourse: temp[i]['exam']['course']['CourseName'],
        examdate: temp[i]['exam']['exam']['Date'],
        slot: temp[i]['exam']['exam']['slot'].toString(),
        startTime: temp[i]['exam']['exam']['startTime'],
        endTime: temp[i]['exam']['exam']['endTime'],
      ));
    }
    setState(() {});
  }

  void AddRecords(Records record) {
    setState(() {
      _records.add(
        DataRow(cells: <DataCell>[
          DataCell(Text('${record.examName}')),
          DataCell(Text('${record.examCode}')),
          DataCell(Text('${record.examCourse}')),
          DataCell(Text('${record.examdate}')),
          DataCell(Text('${record.startTime} - ${record.endTime}')),
          DataCell(Text('${record.slot}')),
        ]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xCFC8C8C8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 1.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Exam Name',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Exam Date',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Exam Code',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Timing',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Slot',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: _records,
            ),
          ),
          TextButton(
            onPressed: () {
              // Respond to button press
            },
            child: Text("Export as CSV"),
          )
        ],
      ),
    );
  }
}
