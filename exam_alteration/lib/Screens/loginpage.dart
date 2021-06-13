import 'package:exam_alteration/graphql/authentication/auth_graph.dart';
import 'package:exam_alteration/graphql/authentication/token.dart';
import 'package:exam_alteration/graphql/graphql.dart';
import 'package:exam_alteration/graphql/graphqlqueries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'Faculty_page.dart';
import 'EDS.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exam_alteration/Screens/ForgotPassword.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              image: AssetImage("images/Login_bg.jpg"),
                              fit: BoxFit.cover,
                            )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Image.asset(
                                  "images/Login_img.png",
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.width / 4,
                                ),
                              ],
                            ),
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
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width / 150,
                              ),
                              LoginForm(),
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

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // ignore: unused_field
  bool _passwordVisible = false;
  bool _obscureText = true;
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _username, _password = "";
  double _formProgress = 0;
  bool inuser = true;
  GraphQLClient _data = GraphQL().getClient();
  GraphQLqueries gq = new GraphQLqueries();
  AuthGraphQL _ag;
  void _validate() async {
    print("Inside validate");
    print("");
    print("");
    print("username " + _username.toString());
    print("password " + _password.toString());
    inuser = true;
    if (_formKey.currentState.validate()) {
      final QueryResult result = await _data.queryCharacter(
          gq.validateUser(username: _username, password: _password));

      if (result.hasException) {
        print("Result is" + result.toString());
        print("Result.hasException is " + result.hasException.toString());
        print("Runtime type " + result.runtimeType.toString());
        setState(() {
          inuser = false;
        });
        _formKey.currentState.validate();
        userNameTextController.clear();
        passwordTextController.clear();
        await Future.delayed(const Duration(seconds: 1));
        _formKey.currentState.validate();
      } else {
        print("Result No exception");
        String _token = result.data['tokenAuth']['token'];
        print("Token is " + _token);

        Provider.of<Token>(context, listen: false).changeToken(_token);
        _ag = new AuthGraphQL();
        _ag.setAuth(_token);

        GraphQLClient _auth = _ag.getClient();
        print("_auth " + _auth.toString());
        final QueryResult auth = await _auth.queryA(gq.getUser());
        print("auth " + auth.toString());
        print("auth.data " + auth.data.toString());
        if (auth.hasException) {
          userNameTextController.clear();
          passwordTextController.clear();
          await Future.delayed(const Duration(seconds: 1));
          _formKey.currentState.validate();
        } else {
          print("auth no exception");
          print("auth is" + auth.toString());
          print("data from auth is " + auth.data.toString());
          String type = auth.data['me']['userT']['type'];
          print("runtimetype of TYPE");
          print(auth.data['me']['userT']['type'].runtimeType);
          String username = auth.data['me']['username'];
          String firstName = auth.data['me']['firstName'];
          String email = auth.data['me']['email'];
          String phonenumber = auth.data['me']['userT']['phno'];
          print(auth.data['me']);
          print(auth.data['userT']);
          print("email " + email.toString());
          print("phonenumber " + phonenumber);
          print("username " + username);
          print("firstname " + firstName);
          switch (type) {
            case 'FACULTY':
              {
                print("Inside faculty");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FacultyScreen(firstName, email, phonenumber)));
              }
              break;
            case 'EXAMDUTYOFFICER':
              {
                print("Inside examdutyofficer");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EDSScreen(firstName, phonenumber, email)));
              }
              break;
            case 'ADMIN':
              {
                print("Inside admin");
                _launchInBrowser('http://127.0.0.1:8000/admin/');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 3),
                    elevation: 2,
                    backgroundColor: Color(0xffFFCE00),
                    content: Text(
                      'Redirecting to FacAssist Admin.....',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Color(0xffE86F1C)),
                    )));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
              break;
            default:
              {
                setState(() {
                  inuser = false;
                });
                _formKey.currentState.validate();
              }
          }
        }
        userNameTextController.clear();
        passwordTextController.clear();
      }
    } else {
      userNameTextController.clear();
      passwordTextController.clear();
      await Future.delayed(const Duration(seconds: 3));
      _formKey.currentState.validate();
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      userNameTextController,
      passwordTextController,
    ];
    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / (controllers.length - 0.5);
      }
    }
    setState(() {
      _formProgress = num.parse(progress.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AnimatedProgressIndicator(value: _formProgress),
          Padding(
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 0.0),
            child: Text(
              'Welcome',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 18,
            ),
            child: TextFormField(
              controller: userNameTextController,
              decoration: InputDecoration(
                labelText: 'Username or Email',
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
              onChanged: (value) => _username = value,
              textInputAction: TextInputAction.next,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: MediaQuery.of(context).size.width / 18,
            ),
            child: TextFormField(
              //keyboardType: TextInputType.text,
              controller: passwordTextController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              validator: (password) {
                Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                RegExp regex = new RegExp(pattern);
                if (password == '') return null;
                if (!regex.hasMatch(password) | !inuser)
                  return 'Invalid password';
                else
                  return null;
              },
              onChanged: (value) => _password = value,

              textInputAction: TextInputAction.done,
            ),
            //
          ),

          Padding(
            padding: const EdgeInsets.only(
                left: 4.0, top: 4.0, right: 4.0, bottom: 4.0),
            child: InkWell(
                splashColor: Colors.red,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()));
                }
                // onTap: () {
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupDialog(context),
                //   );
                // }
                // onTap: () => forgotpassword(),
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
                onPressed: _validate,
                child: Text('Sign in'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  AnimatedProgressIndicator({
    @required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _curveAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    var colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value.withOpacity(0.4),
      ),
    );
  }
}
