import UIKit
import Flutter
import QuickLook

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, QLPreviewControllerDataSource {
    var previewItemURL: URL?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.untitled/documents", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            if call.method == "openFile" {
                guard let args = call.arguments as? [String: Any],
                      let path = args["path"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing path", details: nil))
                    return
                }

                self.previewItemURL = URL(fileURLWithPath: path)
                let previewController = QLPreviewController()
                previewController.dataSource = self

                controller.present(previewController, animated: true, completion: nil)
                result(true)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItemURL! as QLPreviewItem
    }
}

