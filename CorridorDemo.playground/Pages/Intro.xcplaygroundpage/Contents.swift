import Foundation
import UIKit
import PlaygroundSupport
import Corridor

// 1. Protocol for Context
public protocol AppContext {
  var now: Date { get }
}

// 2. Context Implementation for Running App
struct DefaultContext: AppContext {
  var now: Date { return Date() }
}

// 3. HasContext is Corridor base protocol
extension HasContext {
  typealias Context = AppContext
  // provide default resolver
  static var `default`: Resolver<Self, AppContext> {
    return Resolver(context: DefaultContext())
  }
}

// 4. Add resolvable values
extension HasInstanceContext
where Self.Context == AppContext {
  var now: Date {
    return resolve[\.now]
  }
}

// 5. Usage
final class Controller: LabelController, HasInstanceContext {
  var resolve = `default`
  override func viewWillAppear(_ animated: Bool) {
    label.text = "Now is \(now)"
  }
}

PlaygroundPage.current.liveView = Controller()
