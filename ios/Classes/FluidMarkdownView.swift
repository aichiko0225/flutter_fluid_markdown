import Flutter
import UIKit

public class FluidMarkdownView: NSObject, FlutterPlatformView {
  let container: UIView

  init(_ frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    container = UIView(frame: frame)
    if let dict = args as? [String: Any], let markdown = dict["markdown"] as? String {
      let label = UILabel(frame: frame)
      label.text = markdown
      label.numberOfLines = 0
      container.addSubview(label)
    }
  }

  public func view() -> UIView {
    return container
  }
}
