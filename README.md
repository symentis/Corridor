# Corridor

A Coreader-like Dependency Injection Style

## Why

In order to trust our tests we must substitute parts of our code we do not have control over.
Network calls, creating Dates, Keychain, DataStore directories and so forth all have one thing
in common. We need to substitute them in tests in order to verify assumptions.

The purpose of Corridor is:
 - Provide a common interface for _things_ that need to be replaced in TestCases.
 - Simplify instance setup in TestCases without manually providing mocks et all.
 - Transparently provide the actual used context to all your Types.
 - Separate any kind of test related logic from actual running code.


## Usage

In an ideal World a Coeffect is under control.
```swift
class Controller: UIViewController {

  override func viewWillAppear(_ animated: Bool) {
    print(Date())
  }

}
```
The Date in the example is _out of control_.
Running a test for that Controller will always in a different Date.
The Date is a placeholder for any Coeffect.

Corridor tries to solve this problem by taking the concept of a Coreader and
turning it into a Swift friendly implementation via protocols and a single property.
What will it look like?

```swift
class Controller: UIViewController, HasInstanceContext {

  var resolve = `default`

  override func viewWillAppear(_ animated: Bool) {
     print(now)
  }

}
```

## Steps

Your changes:

### Implement one protocol
_Either_ one of the tow provided by Corridor or one you defined that extends one of those.

###  Add one property
Any type that gets access to a injected types need to know how to resolve it.
This is done by providing a property called _resolve_.
By default it should be set to ```var resolve = `default` ````.
Why the backticks?
_default_ is a keyword and by using the backticks the property looks
more _config-ish_.

### Provide access by resolving
In order to resolve, we need to define what can be resolved.
You will see how resolving works in the next part.

## Terminology

### Context
A base protocol that defines your dependencies:

```swift
protocol AppContext {

  /// The current Date
  var now: Date { get }
}
```

### Context Implementation
An implemention of a Context.
Usually we two implementations.
One for the running application, one for the test case.

```swift
struct DefaultContext: AppContext {

  /// The real current Date
  var now: Date {
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

### Resolver
In order to provide the default resolver you must extend the base protocol in
Corridor. This Part will provide a static resolver to your Type in order to provide access.

```swift
extension HasContext {

    typealias Context = AppContext

    static var `default`: Resolver<Self, AppContext> {
       return Resolver(context: DefaultContext())
    }

}
```

The visibility of any property in the context is controlled by extending
either `HasInstanceContext` or `HasStaticContext` or any derived protocol.

```swift
extension HasInstanceContext where Self.Context == AppContext  {

    /// Injected now property
    var now: Date {
        return resolve[\.now]
    }
}
```

### Changing the context
In your actual code everything resolves to the `DefaultContext`.
But in the test you need to make sure to switch that context.
The simplest way is:

```swift
var myController = withContext(Controller(), MockContext())
```

Setting up the context in the Tests can easily be simplified by making
the TestCase itself Context aware. Additionally you can build
functions on top of that to make instantiation automagically with the
correct Context.

```swift
extension HasContext {

    static var mock: Resolver<Self, AppContext> {
        return Resolver(context: MockContext())
    }

}

/// Extension for TestCase (e.g. subclass of XCTestCase)
/// to provide easy access get controller with mock context
extension HasInstanceAppContext where Self: TestCase {


    func withController<V>() -> V?
        where V: UIViewController, V: ManagedByStoryboard, V: HasInstanceAppContext {
        /// A simplified function that will make sure your context is set.
        return self.controller()
    }
}
```

## Installation

### Carthage

To integrate Corridor into your project using Carthage, add to your `Cartfile`:

```ogdl
github "symentis/Corridor"
```

See Carthage for further inststructions.

## Requirements
Swift 4

## Credits
Corridor is owned and maintained by [Symentis GmbH](http://symentis.com).

Developed by: Elmar Kretzer
[![Twitter](https://img.shields.io/badge/twitter-@elmkretzer-blue.svg?style=flat)](http://twitter.com/elmkretzer)



