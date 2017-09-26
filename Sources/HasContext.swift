//
//  HasContext.swift
//  Corridor
//
//  Created by Elmar Kretzer on 06.08.17.
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
// MARK: - Protocols
//
// TL;DR:
// HasContext (only used to pin actual Context)
//  - HasInstanceContext (extend in order to get instance access)
//  - HasStaticContext   (extend in order to get static access)
// --------------------------------------------------------------------------------

/// Base Protocol for static and instance access to `Context`.
/// The Base Protocol is used to pin the `Context` for the
/// 2 protocols that will be used in your Code.
/// - HasInstanceContext
/// - HasStaticContext
/// They are provided in order use a Resolver in a static fashion
/// or as an instance property.
public protocol HasContext {
   associatedtype Context
   associatedtype Source = Self
}

/// Every type that should get access to dependencies on an instance level
/// should conform to `HasInstanceContext`.
/// In order to confirm the Type needs a propery called `resolver`.
/// For structs it works out-of-the-box.
/// For classes make sure to use the final keyword.
/// The actual `resolver` should not be used as it only treated as a flag in order to
/// resolve access from the Context.
///
/// Typical Usage:
///
///     final class ViewController: UIViewController, ContextAware {
///       var resolver = `default`
///     }
///
public protocol HasInstanceContext: HasContext {
  var resolve: Resolver<Self, Context> { get set }
}

/// Every type that should get access to dependencies on an static level
/// should conform to `HasStaticContext`.
/// In order to confirm the Type needs a propery called `resolver`.
/// The actual `resolver` should not be used as it only treated as a flag in order to
/// resolve access from the Context.
///
/// Typical Usage:
///
///     struct StaticThing: ContextAware {
///       static var resolver = `default`
///     }
///
public protocol HasStaticContext: HasContext {
  static var resolve: Resolver<Self, Context> { get set }
}
