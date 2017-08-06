//
//  Contexts.swift
//  MultiversalTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Foundation
import Multiversal

protocol MyContext {

  var now: Date { get }
  var nested: Nested { get }

}

extension MyContext {

   var nested: Nested { return Nested() }

}

struct DefaultContext: MyContext {

  var now: Date { return Date() }

}

struct Mock: MyContext {

  var now: Date { return Date.distantPast }

}
