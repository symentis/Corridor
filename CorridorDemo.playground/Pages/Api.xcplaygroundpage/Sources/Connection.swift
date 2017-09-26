import Foundation

public protocol Connection {
  func getResponse<T: Codable>(_ s: String) -> Future<T>
  var endpoint: Endpoint { get }
}

public struct ServerConnection: Connection {
  public init(){}
  public func getResponse<T: Codable>(_ s: String) -> Future<T> {
    return Future<T>(value: s as! T)
  }
  public var endpoint: String {
    return "https://server.dot.com"
  }
}

public struct MockConnection: Connection {
  public init(){}
  public func getResponse<T: Codable>(_ s: String) -> Future<T> {
    return Future<T>(value: s as! T)
  }
  public var endpoint: String {
    return "https://mock.dot.com"
  }
}

public typealias Dispatch = (String) -> ()

public typealias FutureBind<I, O> = (I) -> Future<O>

public struct Future<T> {

  public var s: T

  public init(value: T){
    self.s = value
  }

  public func flatMap<U>(_ f: (T) -> Future<U>) -> Future<U> {
    return f(self.s)
  }

  public func onSuccess(_ c: (T) -> Void){
    c(s)
  }

}

public extension Date {
  var formatted: String {
    let f = DateFormatter()
    f.dateFormat = "hh:mm:ss.SSSS"
    return f.string(from:self)
  }
}

public typealias Endpoint = String
public typealias UsersEndpoint = String
public typealias UserEndpoint = String
public typealias Address = String
public typealias AddressEndpoint = String

public extension String {

  public var usersEndpoint: String {
    return self + "/users"
  }

  public var firstUserEndpoint: String {
    return self + "/0"
  }

  public var addressEndpoint: String {
    return self + "/address"
  }


}
