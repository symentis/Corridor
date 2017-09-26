import Foundation
import UIKit
import Corridor

// ------------------------------------------------------
// MARK: - Protocol for Context
// ------------------------------------------------------

public protocol AppContext {
  var now: Date { get }
}

// ------------------------------------------------------
// MARK: - Default implementation for Context
// ------------------------------------------------------

struct DefaultContext: AppContext {
  var now: Date { return Date() }
}

// ------------------------------------------------------
// MARK: - General Resolver for base protocol HasContext
// ------------------------------------------------------

public extension HasContext {

  typealias Context = AppContext

  static var `default`: Resolver<Self, AppContext> {
    return Resolver(context: DefaultContext())
  }

}

// ------------------------------------------------------
// MARK: - Actual resolving
// ------------------------------------------------------

protocol ContextAware: HasInstanceContext where Self.Context == AppContext {}

extension ContextAware {
  var now: Date {
    return resolve[\.now]
  }
}

// ------------------------------------------------------
// MARK: - App Usage
// ------------------------------------------------------

public final class Controller: LabelController, ContextAware {

  public var resolve = `default`

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    label.text = "Now is \(now)"
  }

}
