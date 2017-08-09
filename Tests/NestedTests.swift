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

    func testInstanceNested() {
      let t = AType()
      assert(t.nested.now.timeIntervalSince(Date()) < 0.001)

      let m = withContext(AType(), Mock())
      assert(m.nested.now == Date.distantPast)
    }

  func testStaticNested() {
    assert(StaticType.nested.now.timeIntervalSince(Date()) < 0.001)

    withContext(StaticType.self, Mock())
    assert(StaticType.nested.now == Date.distantPast)
  }

}
