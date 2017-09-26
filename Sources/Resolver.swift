//
//  Resolver.swift
//  Corridor
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// --------------------------------------------------------------------------------
// MARK: - Resolver
//
// TL;DR:
// The resolver resolves access to the context for a given Source and Context.
// --------------------------------------------------------------------------------

/// Will be created with
///  - a generic type `S` a.k.a the Source that resolves.
///  - a generic type `C` a.k.a the Context protocol that we are resolving from.
public struct Resolver<S, C>: CustomStringConvertible where S: HasContext {

  /// The typealias for the Context Protocol in your app.
  public typealias Context = C

  /// The typeaias for the Source that holds the resolver.
  public typealias Source = S

  /// The stored context which is used to access the injected types.
  public private(set) var context: C

  /// Inititializer needs a actual implementation of the Context protocol.
  /// example usage:
  ///
  ///     static var mock: Resolver<Self, AppContext> {
  ///        return Resolver(context: MockContext())
  ///     }
  ///
  public init(context: C) {
    self.context = context
  }

  /// A public function to swap the Context for e.g. mocks
  public mutating func apply(_ context: C) {
    self.context = context
  }

  // --------------------------------------------------------------------------------
  // MARK: - Subscripting a.k.a Resolving
  //
  // TL:DR;
  // Subscripts are used to provide a config-ish access to injected values
  // on a protocol level.
  //
  // The examples will use HasInstanceAppContext
  // which is a protocol to pin the Context typealias for convenience.
  // protocol HasInstanceAppContext: HasInstanceContext where Self.Context == AppContext {}
  // --------------------------------------------------------------------------------

  /// Subscripting any regular Type from the Context.
  /// This basic subscribt can be seen as an eqivalent to extract on a Coreader
  /// Example usage:
  ///
  ///     extension HasInstanceAppContext {
  ///
  ///         var now: Date {
  ///            return resolve[\.now]
  ///         }
  ///     }
  ///
  public subscript<D>(_ k: KeyPath<C, D>) -> D {
    return context[keyPath: k]
  }

  /// Subscripting an Type that conforms to `HasInstanceContext` from the Context.
  /// This subscript can be seen as an eqivalent to extend on a Coreader
  /// This will be called when the Type D implements HasInstanceContext,
  /// which will result in passing on the context.
  /// Example usage:
  ///
  ///     extension HasInstanceAppContext {
  ///
  ///         /// Api itself implements HasInstanceAppContext
  ///         var api: Api {
  ///            return resolve[\.api]
  ///         }
  ///     }
  ///
  public subscript<D>(_ k: KeyPath<C, D>) -> D where D: HasInstanceContext, D.Context == C {
    var d = context[keyPath: k]
    d.resolve.apply(context)
    return d
  }

  /// Subscripting an Type that conforms to `HasStaticContext` from the Context.
  /// This subscript can be seen as an eqivalent to extend on a Coreader
  /// This will be called when the Type D implements HasStaticContext,
  /// which will result in passing on the context.
  public subscript<D>(_ k: KeyPath<C, D>) -> D where D: HasStaticContext, D.Context == C {
    D.resolve.apply(context)
    return context[keyPath: k]
  }

  /// Subscripting an Type that conforms to `HasInstanceContext` from the Context.
  /// This is used to provide on-the-fly context passing to types that are not
  ///  defined in the context.
  /// e.g. viewmodels in a controller
  ///
  ///     extension HasInstanceAppContext where Source == MyViewController {
  ///        var myModel: MyModel {
  ///            return resolve[MyModel()]
  ///        }
  ///     }
  ///
  ///     class MyViewController: HasInstanceAppContext {
  ///         var resolve = `default`
  ///         lazy var model: MyModel = { myModel }()
  ///     }
  ///
  public subscript<D>(_ d: D) -> D where D: HasInstanceContext, D.Context == C {
    var dx = d
    dx.resolve.apply(context)
    return dx
  }

  // --------------------------------------------------------------------------------
  // MARK: - CustomStringConvertible
  // --------------------------------------------------------------------------------

  public var description: String {
    return "Resolver with \(context)"
  }

}
