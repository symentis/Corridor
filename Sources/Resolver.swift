//
//  Resolver.swift
//  AnyWorld
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Foundation

// --------------------------------------------------------------------------------
// MARK: - Resolver
// --------------------------------------------------------------------------------

/// Will be created with
///  - a generic type `S` a.k.a the Source that resolves.
///  - a generic type `C` a.k.a the Context protocol that we are resolving from.
public struct Resolver<S, C>: CustomStringConvertible where S: HasContext {

  public typealias Context = C
  public typealias Source = S

  var context: C

  public init(context: C) {
    self.context = context
  }

  /// A public function to swap the Context for e.g. mocks
  public mutating func apply(_ context: C) {
    self.context = context
  }

  // --------------------------------------------------------------------------------
  // MARK: - Subscripting
  // --------------------------------------------------------------------------------

  /// Subscripting any regular Type from the Context.
  public subscript<D>(_ k: KeyPath<C, D>) -> D {
    return context[keyPath: k]
  }

  /// Subscripting an Type that conforms to `HasInstanceContext` from the Context.
  public subscript<D>(_ k: KeyPath<C, D>) -> D where D: HasInstanceContext, D.Context == C {
    var d = context[keyPath: k]
    d.resolve.apply(context)
    return d
  }

  /// Subscripting an Type that conforms to `HasStaticContext` from the Context.
  public subscript<D>(_ k: KeyPath<C, D>) -> D where D: HasStaticContext, D.Context == C {
    D.resolve.apply(context)
    return context[keyPath: k]
  }

  // --------------------------------------------------------------------------------
  // MARK: - CustomStringConvertible
  // --------------------------------------------------------------------------------

  public var description: String {
    return "Resolver with \(context)"
  }

}
