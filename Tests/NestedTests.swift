//
//  CorridorTests.swift
//  CorridorTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import XCTest
import Corridor

class CorridorTests: XCTestCase {

  func testClassWithInline() {
    let t = BType()
    assert(t.now.timeIntervalSince(Date()) < 0.001)
    assert(t.inline.now.timeIntervalSince(Date()) < 0.001)

    let m = withContext(BType(), Mock())
    assert(m.now == Date.distantPast)
    assert(m.inline.now == Date.distantPast)
  }

  func testInstanceNested() {
    let t = AType()
    assert(t.now.timeIntervalSince(Date()) < 0.001)
    assert(t.nested.now.timeIntervalSince(Date()) < 0.001)

    let m = withContext(AType(), Mock())
    assert(m.now == Date.distantPast)
    assert(m.nested.now == Date.distantPast)
  }

  func testStaticNested() {
    assert(StaticType.nested.now.timeIntervalSince(Date()) < 0.001)

    withContext(StaticType.self, Mock())
    assert(StaticType.nested.now == Date.distantPast)
  }

}
