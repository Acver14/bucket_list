import 'package:bucket_list/method/loginMethod.dart';
import 'package:bucket_list/signUpWithEmailPage.dart';
import 'package:flutter/material.dart';
import 'package:bucket_list/provider/firebase_provider.dart';
import 'package:bucket_list/signUpPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constantClass/sizeConstant.dart';
import 'method/methodForFirestore.dart';

LoginWithEmailPageState pageState;

class LoginWithEmailPage extends StatefulWidget {
  @override
  LoginWithEmailPageState createState() {
    pageState = LoginWithEmailPageState();
    return pageState;
  }
}

class LoginWithEmailPageState extends State<LoginWithEmailPage> {
  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  bool doRemember = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void initState() {
    super.initState();
    getRememberInfo();
  }

  @override
  void dispose() {
    setRememberInfo();
    _mailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      //appBar: AppBar(title: Text("Sign-In Page")),
      body: ListView(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Align(
                alignment: Alignment.centerLeft,
                child: new IconButton(icon: new Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Image.asset("assets/logos/iyb.png")
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: <Widget>[
                // Input Area
                Container(
                  child: Column(
                    children: <Widget>[
                      Theme(
                        data: Theme.of(context).copyWith(primaryColor: Colors.black,),
                        child: TextField(
                        controller: _mailCon,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail,),
                          hintText: "Email",
                        ),
                      ),),
                      Theme(
                          data: Theme.of(context).copyWith(primaryColor: Colors.black,),
                          child: TextField(
                            controller: _pwCon,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Password",
                            ),
                            obscureText: true,
                          ),),
                    ].map((c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10),
                        child: c,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          // Remember Me
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Checkbox(
                  activeColor: Colors.black,
                  value: doRemember,
                  onChanged: (newValue) {
                    setState(() {
                      doRemember = newValue;
                    });
                  },
                ),
                Text("Remember Me")
              ],
            ),
          ),

          // Alert Box
          (fp.getUser() != null && fp.getUser().isEmailVerified == false)
              ? Container(
            margin:
            const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(color: Colors.red[300]),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Mail authentication did not complete."
                        "\nPlease check your verification email.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                  color: Colors.lightBlue[400],
                  textColor: Colors.white,
                  child: Text("Resend Verify Email"),
                  onPressed: () {
                    FocusScope.of(context)
                        .requestFocus(new FocusNode()); // 키보드 감춤
                    fp.getUser().sendEmailVerification();
                  },
                )
              ],
            ),
          )
              : Container(),

          // Sign In Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RaisedButton(
              color: Colors.black,
              child: Text(
                "이메일로 시작하기",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                FocusScope.of(context).requestFocus(new FocusNode()); // 키보드 감춤
                await signInWithEmail(context, _scaffoldKey, fp, _mailCon.text, _pwCon.text);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Need an account?",
                    style: TextStyle(color: Colors.blueGrey)),
                FlatButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpWithEmailPage()));
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  getRememberInfo() async {
    logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool("doRemember") ?? false);
    });
    if (doRemember) {
      setState(() {
        _mailCon.text = (prefs.getString("userEmail") ?? "");
        _pwCon.text = (prefs.getString("userPasswd") ?? "");
      });
    }
  }

  setRememberInfo() async {
    logger.d(doRemember);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if (doRemember) {
      prefs.setString("userEmail", _mailCon.text);
      prefs.setString("userPasswd", _pwCon.text);
    }
  }

}