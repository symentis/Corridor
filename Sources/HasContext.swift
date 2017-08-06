//
//  HasContext.swift
//  Multiversal
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

public protocol HasContext {

  associatedtype Source = Self
  associatedtype Context

  var resolve: Resolver<Self, Context> { get set }
}

public func withContext<T: HasContext>(_ t: T, _ c: T.Context) -> T {
  var tx = t
  tx.resolve.apply(c)
  return tx
}
