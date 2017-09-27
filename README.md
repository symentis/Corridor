

# Corridor
_A Coreader-like Dependency Injection μFramework_

[![Build Status](https://travis-ci.org/elm4ward/Corridor.svg?branch=master)](https://travis-ci.org/elm4ward/Corridor)
![Language](https://img.shields.io/badge/language-Swift%204.0-orange.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![@elmkretzer](https://img.shields.io/badge/twitter-@elmkretzer-blue.svg?style=flat)](http://twitter.com/elmkretzer)


# Table of Contents
<a href="#why">Why</a> |
<a href="#examples">Examples</a> |
<a href="#usage">Usage</a> |
<a href="#terminology">Terminology</a> |
<a href="#installation">Installation</a> |
<a href="#credits--license">Credits & License</a> |
</p>

# Why

In order to write tests we must substitute parts of our code that we do not have control over such as:
- Network
- File system
- Creating dates
- Keychain

__We need to substitute them in tests in order to verify assumptions.__

The purpose of Corridor is to:
- Provide a _common interface for things_ that need to be replaced in TestCases
- Simplify _setup in TestCases_ without manually providing mocks etc
- _Transparently provide the current context_ to all your Types
- _Separate any kind of test related logic_ from production code

In an ideal World a Coeffect is under control.

```swift
class Controller: UIViewController {

  override func viewWillAppear(_ animated: Bool) {
    print(Date())
  }
}
```

The Date in the above example is _out of control_.  

Running a test for that Controller will always result in a different Date.
In that case the _Date_ is just a placeholder for any Coeffect.

Corridor tries to solve this problem by taking the concept of a Coreader and turning it into a Swift friendly implementation via protocols and a single property.

_What will it look like?_

```swift
class Controller: UIViewController, HasInstanceContext {

  var resolve = `default`

  override func viewWillAppear(_ animated: Bool) {
     print(now)
  }
}
```

# Examples

See the provided Playground in the workspace for more examples.

# Usage

## Implement a Protocol
_Either_ one of the two protocols provided by Corridor: `HasInstanceContext` or `HasStaticContext`.  
Or any convenience protocol that extends one of those.

##  Add a Property
Any type that needs access to an injected value also needs to know how to resolve it. This is done by providing a property called _resolve_.  

By default it should be set to ```var resolve = `default` ```.  

**Why the backticks?**  
_default_ is a swift keyword and by using the backticks the property looks
more _config-ish_.

# Terminology

## Context
A base protocol that defines your dependencies:

```swift
protocol AppContext {

  /// The current Date
  var now: Date { get }
}
```

## Context Implementation
An implemention of a Context.
Usually we use two implementations.
One for the running application, one for the test cases.

```swift
struct DefaultContext: AppContext {

  var now: Date {
    // The real current Date
    return Date()
  }
}

struct MockContext: AppContext {

  var now: Date {
    // We assume way earlier
    return Date.distantPast
  }
}
```

## Resolver
In order to provide the default resolver you must extend the base protocol in Corridor. This will provide a static variable called `default` of Type Resolver to your Type in order to provide access.  
This extension is done once in your app.

```swift
extension HasContext {

    typealias Context = AppContext

    static var `default`: Resolver<Self, AppContext> {
       return Resolver(context: DefaultContext())
    }
}
```

The visibility of any property in the context is controlled by extending either `HasInstanceContext` or `HasStaticContext` or any derived protocol.  

By using protocols we can constrain access in a granular way. Additionally it allows for the injection of functions.  

_See example CorridorDemo.playground._

```swift
extension HasInstanceContext where Self.Context == AppContext  {

    /// Injected now property
    var now: Date {
        return resolve[\.now]
    }
}
```

## Changing the Context
In your actual code everything resolves to the `DefaultContext`.  
But in your Tests you need to make sure to switch to the mock context.  
The simplest way is:

```swift
var myController = withContext(Controller(), MockContext())
```

Setting up the context in the Tests can easily be simplified by making the TestCase itself Context aware. Additionally you can build functions on top of that to make instantiation automagically have the correct Context.

```swift
extension HasContext {

    static var mock: Resolver<Self, AppContext> {
        return Resolver(context: MockContext())
    }
}

/// Extension for TestCase (e.g. subclass of XCTestCase)
/// to provide easy access to get controller with mock context
extension HasInstanceAppContext where Self: TestCase {

    func withController<V>() -> V?
        where V: UIViewController, V: ManagedByStoryboard, V: HasInstanceAppContext {
        /// A simplified function that will make sure your context is set
        return self.controller()
    }
}
```

# Installation

## Carthage

To integrate Corridor into your project using Carthage, add to your `Cartfile`:

```ogdl
github "symentis/Corridor"
```

See [Carthage](https://github.com/Carthage/Carthage) for further inststructions.

# Requirements
Swift 4

# Credits & License
Corridor is owned and maintained by [Symentis GmbH](http://symentis.com).

Developed by: Elmar Kretzer
[![Twitter](https://img.shields.io/badge/twitter-@elmkretzer-blue.svg?style=flat)](http://twitter.com/elmkretzer)

All modules are released under the MIT license. See LICENSE for details.
