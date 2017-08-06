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
public protocol HasContext {

  associatedtype Source = Self
  associatedtype Context

  var resolve: Resolver<Self, Context> { get set }
}

/// A function to apply a new Context
public func withContext<T: HasContext>(_ t: T, _ c: T.Context) -> T {
  var tx = t
  tx.resolve.apply(c)
  return tx
}
