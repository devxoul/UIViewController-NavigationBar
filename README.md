UIViewController+NavigationBar
==============================

[![Build Status](https://travis-ci.org/devxoul/UIViewController-NavigationBar.svg?branch=master)](https://travis-ci.org/devxoul/UIViewController-NavigationBar)
[![CocoaPods](http://img.shields.io/cocoapods/v/UIViewController+NavigationBar.svg)](https://cocoapods.org/pods/UIViewController+NavigationBar)

UIViewController with its own navigation bar. It provides smooth push animations between view controllers which have different navigation bar styles.

![uiviewcontroller navigationbar mov](https://cloud.githubusercontent.com/assets/931655/12593208/391d243a-c4b3-11e5-9a05-831f3c72753d.gif)


At a Glance
-----------

Override `hasCustomNavigationBar` method to use custom navigation bar. Then you can use `navigationBar` property on `UIViewController`.

```swift
class MyViewController: UIViewController {

    override func hasCustomNavigationBar() -> Bool {
        return true // I'm gonna use custom navigation bar!
    }

}

let viewController = MyViewController()
viewController.navigationBar.barTintColor = .purpleColor() // Use custom navigation bar
viewController.navigationItem.title = "Hello" // Change navigationItem property
```

> **Note**: Don't confuse with `UINavigationController`'s `navigationBar`.


### Hiding System Navigation Bar

With **UIViewController+NavigationBar**, you have to do something additional to make system navigation bar hidden.

```swift
class MyViewController: UIViewController {

    /// Override this method to make built-in navigation bar hidden
    override func prefersNavigationBarHidden() -> Bool {
        return true
    }

}
```


Installation
------------

I recommend you to use [CocoaPods](http://cocoapods.org) with **`Podfile`**:

```ruby
pod 'UIViewController+NavigationBar'
```


License
-------

**UIViewController+NavigationBar** is under MIT license. See the [LICENSE](LICENSE) file for more info.
