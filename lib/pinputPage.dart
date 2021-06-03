import 'package:bucket_list/bucketListPage.dart';
import 'package:bucket_list/method/localAuthMethod.dart';
import 'package:bucket_list/method/printLog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:local_auth/local_auth.dart';

var _isPinRegister;
class PinPutPage extends StatefulWidget {
  var isPinRegister;
  PinPutPage({Key key, @required this.isPinRegister}) : super(key: key);
  @override
  PinPutPageState createState() {
    _isPinRegister = isPinRegister;
    return PinPutPageState();
  }
}

class PinPutPageState extends State<PinPutPage> {
  final _pinPutController = new TextEditingController();
  final _pinPutFocusNode = FocusNode();
  String _pin;
  static final _auth = LocalAuthentication();
  static var isAvailable;


  @override
  void initState() {
    loadPinPut().then((ret){
      _pin = ret;
    });
    //authenticate();
    super.initState();
  }

  static Future<bool> hasBiometrics() async{
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e){
      return false;
    }
  }

  static Future<void> authenticate(BuildContext context) async{
    isAvailable = await hasBiometrics();
    bool _authCheck = false;
    if(!isAvailable) return false;
    try{
      _authCheck = await _auth.authenticateWithBiometrics(
          localizedReason: '지문 인식을 진행해주십시오.',
          useErrorDialogs: true,
          stickyAuth: true
      );
    } on PlatformException catch (e){
      return false;
    }
    if(_authCheck) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BucketListPage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    authenticate(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: 1.0,
            child: Center(child: darkRoundedPinPut()),
          )
        ],
      ),
    );
  }

  Widget darkRoundedPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(25, 21, 99, 1),
      borderRadius: BorderRadius.circular(20.0),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height:70),
        PinPut(
          eachFieldWidth: 65.0,
          eachFieldHeight: 65.0,
          withCursor: true,
          fieldsCount: 4,
          focusNode: _pinPutFocusNode,
          controller: _pinPutController,
          onSubmit: (String pin) {
            printLog(checkPin(pin).toString());
            if(_isPinRegister){
              if(isInt(pin)) {
                registerPin(pin);
                _showSnackBar('핀 번호가 저장되었습니다.');
                printLog(pin);
                Navigator.pop(context);
              }
              else{
                _showSnackBar('핀 번호는 숫자로 설정해주세요.');
                savePinPut('----');
              }
            }
            else if(checkPin(pin)){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => BucketListPage()));
            }
            else{
              _showSnackBar('핀 번호를 확인해주세요.');
            }
          },
          submittedFieldDecoration: pinPutDecoration,
          selectedFieldDecoration: pinPutDecoration,
          followingFieldDecoration: pinPutDecoration,
          pinAnimationType: PinAnimationType.scale,
          textStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: const EdgeInsets.all(30),
          physics: NeverScrollableScrollPhysics(),
          children: [
            ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0, ].map((e) {
              return Container(
                width: 10,
                  height: 5,
                  child: RaisedButton(
                    color: Colors.white,
                    child: Text('$e'),
                    onPressed: ()  {
                      _pinPutController.text = '${_pinPutController.text}$e';
                    },
                  )
              );
            }),
            RaisedButton(
              child: Text('<-'),
              onLongPress: (){
                _pinPutController.text = '';
              },
              onPressed: () {
                if (_pinPutController.text.isNotEmpty) {
                  _pinPutController.text = _pinPutController.text
                      .substring(0, _pinPutController.text.length - 1);
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.fingerprint),
              onPressed: () async {
                await authenticate(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  bool checkPin(String pin){
    printLog((pin ==_pin).toString());
    return pin == _pin;
  }

  registerPin(String pin) async {
    await savePinPut(pin);
  }

  void _showSnackBar(String str) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Container(
        height: 60.0,
        child: Center(
          child: Text(
            str,
            style: const TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      backgroundColor: Colors.deepPurpleAccent,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  bool isInt(String str) { if(str == null) { return false; } return int.tryParse(str) != null; }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  RoundedButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromRGBO(25, 21, 99, 1),
        ),
        alignment: Alignment.center,
        child: Text(
          '$title',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}