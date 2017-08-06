//: Playground - noun: a place where people can play

import UIKit
import AnyWorld

// ----------------------------------------------------------------------------------------------------
// MARK: - Context
// ----------------------------------------------------------------------------------------------------

protocol AppContext {
  var now: Date { get }
  var nested: Nested { get }
}

// ----------------------------------------------------------------------------------------------------
// MARK: - DefaultContext
// ----------------------------------------------------------------------------------------------------

struct DefaultContext: AppContext {

  var now: Date { return Date() }
  var nested: Nested { return Nested() }

}

// ----------------------------------------------------------------------------------------------------
// MARK: - Resolving
// ----------------------------------------------------------------------------------------------------

extension HasContext {

  typealias Context = AppContext

  static var `default`: Resolver<Self, AppContext> {
    return Resolver(context: DefaultContext())
  }

}

extension HasContext where Source == AType, Context == AppContext {

  var nested: Nested {
    return resolve[\.nested]
  }
}

extension HasContext where Source == Nested, Context == AppContext {
  var now: Date {
    return resolve[\.now]
  }
}

// ----------------------------------------------------------------------------------------------------
// MARK: - Types
// ----------------------------------------------------------------------------------------------------

struct Nested: HasContext {
  var resolve = `default`
}

struct AType: HasContext {
  var resolve = `default`
}

// ----------------------------------------------------------------------------------------------------
// MARK: - Running
// ----------------------------------------------------------------------------------------------------

let t = AType()
print(t.nested.now)

// ----------------------------------------------------------------------------------------------------
// MARK: - Mock
// ----------------------------------------------------------------------------------------------------

struct Mock: AppContext {

  var now: Date { return Date.distantPast }
  var nested: Nested { return Nested() }

}

let m = withContext(AType(), Mock())
print(m.nested.now)
