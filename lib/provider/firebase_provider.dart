import 'dart:convert';
import 'dart:io';

import 'package:bucket_list/method/printLog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:apple_sign_in_firebase/apple_sign_in_firebase.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

Logger logger = Logger();

class FirebaseProvider with ChangeNotifier {
  final FirebaseAuth fAuth = FirebaseAuth.instance; // Firebase 인증 플러그인의 인스턴스
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser _user; // Firebase에 로그인 된 사용자
  var _userInfo;

  String _lastFirebaseResponse = ""; // Firebase로부터 받은 최신 메시지(에러 처리용)

  FirebaseProvider() {
    logger.d("init FirebaseProvider");
    _prepareUser();
  }

  FirebaseUser getUser() {
    return _user;
  }

  getUserInfo(){
    return _userInfo;
  }

  void setUser(FirebaseUser value) {
    _user = value;
    notifyListeners();
  }

  setUserInfo() async {
    _userInfo = await Firestore.instance
        .collection(getUser().uid)
        .document('user_info').get().then((value) {
      printLog(value.data.toString());
      return value;
    });
    notifyListeners();
  }

  // 최근 Firebase에 로그인한 사용자의 정보 획득
  _prepareUser() {
    fAuth.currentUser().then((FirebaseUser currentUser) async {
      setUser(currentUser);
      await setUserInfo();
    });
  }

  // 이메일/비밀번호로 Firebase에 회원가입
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      AuthResult result = await fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        // 인증 메일 발송
        result.user.sendEmailVerification();
        // 새로운 계정 생성이 성공하였으므로 기존 계정이 있을 경우 로그아웃 시킴
        signOut();
        return true;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // 이메일/비밀번호로 Firebase에 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var result = await fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        setUser(result.user);
        setUserInfo();
        logger.d(getUser());
        return true;
      }
      return false;
    } on Exception catch (e) {
      logger.e(e.toString());
      if(e.toString().contains('ERROR_USER_NOT_FOUND')){
        setLastFBMessage('가입된 정보가 없어 입력하신 이메일로 인증 바랍니다.');
        await signUpWithEmail(email, password);
      }
      else{
        List<String> result = e.toString().split(", ");
        setLastFBMessage(result[1]);
      }
      return false;
    }
  }

  // 구글 계정을 이용하여 Firebase에 로그인
  Future<bool> signInWithGoogleAccount() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final FirebaseUser user =
          (await fAuth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await fAuth.currentUser();
      assert(user.uid == currentUser.uid);
      setUser(user);
      setUserInfo();
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // 카카오 계정을 이용하여 Firebase에 로그인
  Future<bool> signInWithKakaoAccount() async {
    try{
      var isKakaoInstalled = await isKakaoTalkInstalled();
      String authCode;
      if(isKakaoInstalled){
        authCode = await AuthCodeClient.instance.requestWithTalk();
      }else{
        authCode = await AuthCodeClient.instance.request();
      }
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      printLog(token.accessToken);
      final http.Response uid = await http.post(
        'https://kapi.kakao.com/v2/user/me',
        headers: {
          "Authorization": "Bearer ${token.accessToken}"
        },
      );
      printLog("user id : " + uid.body);

      final http.Response response = await http.post(
        'https://asia-northeast3-bucket-list-38be8.cloudfunctions.net/makeAndSendCustomToken',
        body: {
          "token": "Kakao${jsonDecode(uid.body)['id'].toString()}"
        },
      );

      printLog(response.body);

      final AuthResult authResult = await fAuth.signInWithCustomToken(token: response.body);
      final FirebaseUser user = authResult.user;
      final FirebaseUser currentUser = await fAuth.currentUser();
      assert(user.uid == currentUser.uid);
      setUser(user);
      setUserInfo();

      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // 네이버 계정을 이용하여 Firebase에 로그인
  Future<bool> signInWithNaverAccount() async {
    try{
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
      var uid = result.account.id;

      printLog(uid);
      printLog(result.account.email);
      final http.Response response = await http.post(
        'https://asia-northeast3-bucket-list-38be8.cloudfunctions.net/makeAndSendCustomToken',
        body: {
          "token": "Naver$uid"
        },
      );
      final AuthResult authResult = await fAuth.signInWithCustomToken(token: response.body);
      final FirebaseUser user = authResult.user;
      final FirebaseUser currentUser = await fAuth.currentUser();
      assert(user.uid == currentUser.uid);
      setUser(user);
      setUserInfo();

      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }

  Future<bool> signInWithAppleAccount() async {
    try {
      if (Platform.isIOS) {
        if (!await AppleSignIn.isAvailable()) {
          logger.e('애플 로그인 사용 불가');
          setLastFBMessage('해당 소프트웨어 버전에서는 애플 로그인을 사용할 수 없습니다.');
          return false;
        }
        AuthorizationRequest authorizationRequest = AppleIdRequest(
            requestedScopes: [Scope.email, Scope.fullName]);
        AuthorizationResult authorizationResult = await AppleSignIn
            .performRequests([authorizationRequest]);
        logger.d(authorizationResult);
        AppleIdCredential appleCredential = authorizationResult.credential;

        OAuthProvider provider = new OAuthProvider(providerId: "apple.com");
        logger.d(appleCredential.toString());
        AuthCredential credential = provider.getCredential(
          idToken: String.fromCharCodes(appleCredential.identityToken),
          accessToken: String.fromCharCodes(
              appleCredential.authorizationCode),);
        FirebaseAuth auth = FirebaseAuth.instance;
        AuthResult authResult = await auth.signInWithCredential(credential);
        // 인증에 성공한 유저 정보
        FirebaseUser user = authResult.user;
        String name = appleCredential.fullName.givenName;
        logger.d('user name for apple : ${name}');
        setUser(user);
        setUserInfo();
      } else {
        final Map appleCredential = await AppleSignInFirebase.signIn();
        //logger.d(String.fromCharCodes(appleCredential['idToken']));
        OAuthProvider provider = new OAuthProvider(providerId: "apple.com");
        AuthCredential credential = provider.getCredential(
          idToken: appleCredential['idToken'],
          accessToken: appleCredential['accessToken'],);
        FirebaseAuth auth = FirebaseAuth.instance;
        AuthResult authResult = await auth.signInWithCredential(credential);
        // 인증에 성공한 유저 정보
        FirebaseUser user = authResult.user;
        setUser(user);
        setUserInfo();
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
    return true;
  }

  // Firebase로부터 로그아웃
  signOut() async {
    await fAuth.signOut();
    setUser(null);
  }

  // 사용자에게 비밀번호 재설정 메일을 영어로 전송 시도
  sendPasswordResetEmailByEnglish() async {
    await fAuth.setLanguageCode("en");
    sendPasswordResetEmail();
  }

  // 사용자에게 비밀번호 재설정 메일을 한글로 전송 시도
  sendPasswordResetEmailByKorean() async {
    await fAuth.setLanguageCode("ko");
    sendPasswordResetEmail();
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  sendPasswordResetEmail() async {
    fAuth.sendPasswordResetEmail(email: getUser().email);
  }

  // Firebase로부터 회원 탈퇴
  withdrawalAccount() async {
    await getUser().delete();
    setUser(null);
  }

  // Firebase로부터 수신한 메시지 설정
  setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }
}