//
//  HasContext.swift
//  Corridor
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

// --------------------------------------------------------------------------------
// MARK: - HasContext
// --------------------------------------------------------------------------------

/// Base Protocol for static and instance access to Context
public protocol HasContext {
   associatedtype Context
   associatedtype Source = Self
}

/// Every type that should get access to dependencies on an instance level
/// should conform to `HasInstanceContext`.
/// In order to confirm the Type needs a propery called `resolver`.
///
/// Typical Usage:
///
///     final class ViewController: UIViewController, ContextAware {
///       var resolver = `default`
///     }
///
public protocol HasInstanceContext: HasContext {
  var resolve: Resolver<Self, Context> { get set }
}

/// Every type that should get access to dependencies on an static level
/// should conform to `HasStaticContext`.
/// In order to confirm the Type needs a propery called `resolver`.
///
/// Typical Usage:
///
///     final class ViewController: UIViewController, ContextAware {
///       var resolver = `default`
///     }
///
public protocol HasStaticContext: HasContext {
  static var resolve: Resolver<Self, Context> { get set }
}

// --------------------------------------------------------------------------------
// MARK: - Explicit Context Setter
// --------------------------------------------------------------------------------

/// A function to apply a new Context
public func withContext<T: HasInstanceContext>(_ t: T, _ c: T.Context) -> T {
  var tx = t
  tx.resolve.apply(c)
  return tx
}

/// A function to apply a new Context
public func withContext<T: HasStaticContext>(_ t: T.Type, _ c: T.Context) {
  T.resolve.apply(c)
}
