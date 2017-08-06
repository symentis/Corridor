//
//  Resolver.swift
//  Multiversal
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Foundation

public struct Resolver<S, C>: ResolvesContext, CustomStringConvertible
where S: HasContext {

  public typealias Context = C
  public typealias Source = S

  var context: C

  public init(context: C) {
    self.context = context
  }

  public mutating func apply(_ context: C) {
    self.context = context
  }

  public subscript<D>(_ k: KeyPath<C, D>) -> D {
    return context[keyPath: k]
  }

  public subscript<D>(_ k: KeyPath<C, D>) -> D where D: HasContext, D.Context == C {
    var d = context[keyPath: k]
    d.resolve.apply(context)
    return d
  }

  public var description: String {
    return "Resolver with \(context)"
  }

}
