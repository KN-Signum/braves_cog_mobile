import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 1. Register all plugins (THIS IS THE MISSING LINK)
    GeneratedPluginRegistrant.register(with: self)
    
    // 2. Set notification delegate
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle notification when app is in foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    var options: UNNotificationPresentationOptions = [.badge, .sound]
    
    if #available(iOS 14.0, *) {
      options.insert(.banner)
    } else {
      options.insert(.alert)
    }
    
    completionHandler(options)
  }
}