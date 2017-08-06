//
//  Contexts.swift
//  AnyWorldTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Foundation
import AnyWorld

protocol MyContext {

  var now: Date { get }
  var nested: Nested { get }

}

struct DefaultContext: MyContext {

  var now: Date { return Date() }
  var nested: Nested { return Nested() }

}

struct Mock: MyContext {

  var now: Date { return Date.distantPast }
  var nested: Nested { return Nested() }

}
