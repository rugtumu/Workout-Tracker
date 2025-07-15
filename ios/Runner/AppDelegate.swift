import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure for App Store
    if #available(iOS 13.0, *) {
      // Enable Face ID/Touch ID for biometric authentication
      let context = LAContext()
      if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
        // Biometric authentication is available
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
