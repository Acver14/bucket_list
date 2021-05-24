import 'package:url_launcher/url_launcher.dart';

launchBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false, forceWebView: false);
  } else {
    throw 'could not launch';
  }
}