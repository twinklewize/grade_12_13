import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let registrer = self.registrar(forPlugin: "NativeViewPlugin") {
      NativeViewPlugin.register(with: registrer)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
