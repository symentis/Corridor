//
//  AnyWorldTests.swift
//  AnyWorldTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import XCTest
import AnyWorld

class AnyWorldTests: XCTestCase {

    func testNested() {
      let t = AType()
      assert(t.nested.now.timeIntervalSince(Date()) < 0.000)

      let m = withContext(AType(), Mock())
      assert(m.nested.now == Date.distantPast)
    }

}
