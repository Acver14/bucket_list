import UIKit
import Flutter
import Firebase
import GoogleMaps
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ app: UIApplication, open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBBNnJ6OcABWU1t33pBEl8w-IpzesX1iWk")
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
  }
}