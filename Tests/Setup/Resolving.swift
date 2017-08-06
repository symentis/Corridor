//
//  Resolving.swift
//  MultiversalTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Multiversal
import Foundation

extension HasContext {

  typealias Context = MyContext

  static var `default`: Resolver<Self, MyContext> {
    return Resolver(context: DefaultContext())
  }

}

extension HasContext where Source == AType, Context == MyContext {

  var nested: Nested {
    return resolve[\.nested]
  }
}

extension HasContext where Source == Nested, Context == MyContext {

  var now: Date {
    return resolve[\.now]
  }
}
