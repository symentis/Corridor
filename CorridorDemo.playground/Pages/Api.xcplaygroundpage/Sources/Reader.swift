public struct Reader<E, A> {

  let f: (E) -> A

  public init(_ f: @escaping (E) -> A) {
    self.f = f
  }

  public static func unit<E, A>(_ a: A) -> Reader<E, A> {
    return Reader<E, A> { _ in a }
  }

  public func run(_ e: E) -> A {
    return f(e)
  }

  public func map<B>(_ m: @escaping (A) -> B) -> Reader<E, B> {
    return Reader<E, B> { m(self.f($0)) }
  }

  public func flatMap<B>(_ b: @escaping (A) -> Reader<E, B>) -> Reader<E, B> {
    return Reader<E, B> { e in
      b(self.run(e)).run(e)
    }
  }
}

precedencegroup Kleisli { associativity: left }
infix operator >=> : Kleisli

public func >=> <E, A, B, C>(ra: @escaping (A) -> Reader<E, B>,
                             rb: @escaping (B) -> Reader<E, C>) -> (A) -> Reader<E, C> {
  return { a in
    Reader { env in
      ra(a).flatMap { x in rb(x) }.run(env)
    }
  }
}
