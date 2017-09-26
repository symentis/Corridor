//
//  Functions.swift
//  Corridor
//
//  Created by Elmar Kretzer on 26.09.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// --------------------------------------------------------------------------------
// MARK: - Helper Functions
//
// TL;DR:
// Those to functions allow passing on a
// provided context implementation to a type conforming to:
// - HasInstanceContext
// - HasStaticContext
// --------------------------------------------------------------------------------

/// A function to apply a new Context HasInstanceContext
/// Example usage: When your TestCase extends HasInstanceContext and
/// the context for test provides a Type taht can instantiate controllers it
/// coule be implemented this way:
///
///     struct Storymock: ControllerInstantiator {
///         static func instantiate<V>() -> V
///             where V: ManagedByStoryboard, V: UIViewController, V: HasInstanceAppContext {
///             let v: V = Storyboard.instantiate()
///             return withContext(v, MockContext())
///         }
///    }
///
public func withContext<T: HasInstanceContext>(_ t: T, _ c: T.Context) -> T {
  var tx = t
  tx.resolve.apply(c)
  return tx
}

/// A function to apply a new Context on HasStaticContext
public func withContext<T: HasStaticContext>(_ t: T.Type, _ c: T.Context) {
  T.resolve.apply(c)
}
