//
//  HasContext.swift
//  AnyWorld
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

// --------------------------------------------------------------------------------
// MARK: - HasContext
// --------------------------------------------------------------------------------

/// Every type that should get access to dependencies should conform to `HasContext`.
/// In order to confirm the Type needs a propery called `resolver`.
///
/// Typical Usage:
///
///     final class ViewController: UIViewController, ContextAware {
///       var resolver = `default`
///     }
///

public protocol ContextAware {
   associatedtype Context
}

public protocol HasContext: ContextAware {
  associatedtype Source = Self
  var resolve: Resolver<Self, Context> { get set }
}

public protocol HasStaticContext: ContextAware {
  associatedtype Source = Self
  static var resolve: StaticResolver<Self, Context> { get set }
}

/// A function to apply a new Context
public func withContext<T: HasContext>(_ t: T, _ c: T.Context) -> T {
  var tx = t
  tx.resolve.apply(c)
  return tx
}

/// A function to apply a new Context
public func withStaticContext<T: HasStaticContext>(_ t: T.Type, _ c: T.Context) {
  T.resolve.apply(c)
}
