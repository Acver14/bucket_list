import UIKit
import Flutter
import Firebase
import GoogleMaps
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBqQqJsG6d2NrdwEgQK-3rGzpB0IFq5qyg")
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(
                _ app: UIApplication,
                open url: URL,
                options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
        var result = false
        NSLog("URL = \(url.absoluteString)")
        if url.absoluteString.hasPrefix("kakao"){ result = super.application(app, open: url, options: options)
            
        }
        if !result{
            if(NaverThirdPartyLoginConnection.getSharedInstance() != nil){
                let instance = NaverThirdPartyLoginConnection.getSharedInstance()

                if(instance != nil){
                // 네이버 앱으로 인증하는 방식을 활성화
                    instance?.isNaverAppOauthEnable = true
                    // SafariViewController에서 인증하는 방식을 활성화
                    instance?.isInAppOauthEnable = true
                    // 인증 화면을 iPhone의 세로 모드에서만 사용하기
                    instance?.isOnlyPortraitSupportedInIphone()
                    // 네이버 아이디로 로그인하기 설정
                    // 애플리케이션을 등록할 때 입력한 URL Scheme
                    instance?.serviceUrlScheme = //"https://asia-northeast3-bucket-list-38be8.cloudfunctions.net"
                        "naverLogin"
                    // 애플리케이션 등록 후 발급받은 클라이언트 아이디
                    instance?.consumerKey = "_mC3dn8WxMzuyn7hlj4x"
                    // 애플리케이션 등록 후 발급받은 클라이언트 시크릿
                    instance?.consumerSecret = "pJS9Ppkrsh"
                    // 애플리케이션 이름
                    instance?.appName = "inYourBucket"
                }

                return ((instance?.application(app, open: url, options: options)) != nil)
            }
        }

            return false
        }
}

