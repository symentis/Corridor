//
//  Resolving.swift
//  CorridorTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Corridor
import Foundation

extension HasContext {

  typealias Context = MyContext

  static var `default`: Resolver<Self, MyContext> {
    return Resolver(context: DefaultContext())
  }

}

extension HasInstanceContext where Context == MyContext {

  var now: Date {
    return resolve[\.now]
  }
}

extension HasInstanceContext where Source == AType, Context == MyContext {

  var nested: Nested {
    return resolve[\.nested]
  }

}

extension HasInstanceContext where Source == BType, Context == MyContext {

  var inlineResolved: InlineResolver {
    return resolve[InlineResolver()]
  }
}

extension HasStaticContext where Source == StaticType, Context == MyContext {

  static var nested: Nested {
    return resolve[\.nested]
  }
}
