import Foundation
import UIKit
import PlaygroundSupport
import Corridor

// 1. Protocol for Context
protocol AppContext {
  var now: Date { get }
  var api: Api { get }
}

// 2. Context Implementation for Running App
struct DefaultContext: AppContext {
  var now: Date { return Date() }
  var api: Api { return Api(connection: ServerConnection()) }
}

// 3. Context Implementation for Test App
struct MockContext: AppContext {
  var now: Date { return Date.distantPast }
  var api: Api { return Api(connection: MockConnection()) }
}

// 4. Extend Corridor
extension HasContext {
  typealias Context = AppContext
  static var `default`: Resolver<Self, AppContext> {
    return Resolver(context: DefaultContext())
  }
}

// 5. Convenience protocol
protocol ContextAware: HasInstanceContext
where Self.Context == AppContext {}

// 6. Define API for (String) -> Future<T>
struct Api: ContextAware {
  var resolve = `default`
  let connection: Connection
  init(connection: Connection) {
    self.connection = connection
  }
  var endpoint: Endpoint {
    return connection.endpoint
  }
  func getResponse<T: Codable>(_ s: String) -> Future<T> {
    return connection.getResponse(s)
  }
}

// 7. Fake ReSwift Store
var dispatched: Set<String> = Set()

// 8. Extend Corridor
extension ContextAware {
  // Extract
  var now: Date {
    return resolve[\.now]
  }
  // Extend
  var api: Api {
    return resolve[\.api]
  }
  var dispatch: Dispatch {
    return { dispatched.insert($0) }
  }
  var messages: String {
    return dispatched.sorted().joined(separator: "\n")
  }
}

// 9. Define API Operations
typealias ApiAware<O> = Reader<Api, O>
typealias ApiFuture<O> = ApiAware<Future<O>>
typealias ApiBind<I, O> = (Future<I>) -> ApiFuture<O>

func bind<I, O>(_ urlFrom: @escaping (I) -> String) -> ApiBind<I, O>
  where O: Codable {
    return { future in
      ApiAware { api in
        future.flatMap { input in
          api.dispatch("\(api.now.formatted) \n -\(input)")
          return api.getResponse(urlFrom(input))
        }
      }
    }
}

let apiEntrypoint: ApiFuture<Endpoint> = ApiAware { api in
  Future<Endpoint>(value: api.endpoint)
}
let usersEndpoint: ApiBind<Endpoint, UsersEndpoint> = bind {
  $0.usersEndpoint
}
let firstUserEndpoint: ApiBind<UsersEndpoint, UserEndpoint> = bind {
  $0.firstUserEndpoint
}
let addressEndpoint: ApiBind<UserEndpoint, AddressEndpoint> = bind {
  $0.addressEndpoint
}

let apiCall = usersEndpoint >=> firstUserEndpoint >=> addressEndpoint

// 10. Controller
final class Controller: LabelController, ContextAware {

  var resolve = `default`

  override func viewWillAppear(_ animated: Bool) {

    let address = apiEntrypoint
      .flatMap(apiCall)
      .run(api)

    address.onSuccess { (s: Address) in
      label.text = messages + "\n" + s

    }
  }
}

// 11. Run
let app = Controller()
let test = withContext(Controller(), MockContext())
PlaygroundPage.current.liveView = app



