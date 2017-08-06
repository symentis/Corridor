//
//  MultiversalTests.swift
//  MultiversalTests
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import XCTest
import Multiversal

class MultiversalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
      let t = AType()
      assert(t.nested.now.timeIntervalSince(Date()) < 0.000)

      let m = withContext(AType(), Mock())
      assert(m.nested.now == Date.distantPast)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
