import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let launchOverlayTag = 12345

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    // iOS: Flutter ilk kareyi çizene kadar LaunchImage ile overlay göster (beyaz ekranı önler)
    DispatchQueue.main.async { [weak self] in
      self?.addLaunchOverlayAndChannel()
    }

    return result
  }

  private func addLaunchOverlayAndChannel() {
    guard let window = self.window,
          let flutterVC = window.rootViewController as? FlutterViewController else { return }

    let view = flutterVC.view!
    let overlay = UIView(frame: view.bounds)
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlay.backgroundColor = .white
    overlay.tag = launchOverlayTag

    let imgView = UIImageView(image: UIImage(named: "LaunchImage"))
    imgView.contentMode = .scaleAspectFit
    imgView.translatesAutoresizingMaskIntoConstraints = false
    overlay.addSubview(imgView)
    NSLayoutConstraint.activate([
      imgView.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
      imgView.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
      imgView.widthAnchor.constraint(lessThanOrEqualTo: overlay.widthAnchor, multiplier: 0.6),
      imgView.heightAnchor.constraint(lessThanOrEqualTo: overlay.heightAnchor, multiplier: 0.5),
    ])

    view.addSubview(overlay)

    let channel = FlutterMethodChannel(
      name: "solicap/launch",
      binaryMessenger: flutterVC.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "removeOverlay" {
        self?.removeLaunchOverlay()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func removeLaunchOverlay() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self,
            let window = self.window,
            let rootVC = window.rootViewController,
            let overlay = rootVC.view.viewWithTag(self.launchOverlayTag) else { return }
      UIView.animate(withDuration: 0.25, animations: { overlay.alpha = 0 }) { _ in
        overlay.removeFromSuperview()
      }
    }
  }
}
