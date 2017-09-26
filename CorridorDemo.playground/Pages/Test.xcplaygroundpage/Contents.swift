import Foundation
import PlaygroundSupport
import Corridor

// 1. Context Implementation for Testing App
struct MockContext: AppContext {
  var now: Date { return Date.distantPast }
}

// 2. Usage
let test = withContext(Controller(), MockContext())

PlaygroundPage.current.liveView = test



