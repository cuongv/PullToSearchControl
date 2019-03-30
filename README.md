# PullToSearchControl
This CocoaPods library helps you add pull to search behaviour for UIScrollView or its descendants, such as UITableView or UICollectionView.

![PullToSearchControl2](https://user-images.githubusercontent.com/992197/55276392-4dc70380-532e-11e9-9122-564938fa8e71.gif)

[![Platform](https://img.shields.io/cocoapods/p/UICollectionViewSplitLayout.svg?style=flat)](http://cocoapods.org/pods/UICollectionViewSplitLayout)
![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg)
[![License](https://img.shields.io/cocoapods/l/UICollectionViewSplitLayout.svg?style=flat)](http://cocoapods.org/pods/UICollectionViewSplitLayout)
[![Version](https://img.shields.io/cocoapods/v/UICollectionViewSplitLayout.svg?style=flat)](http://cocoapods.org/pods/UICollectionViewSplitLayout)


# What's this?
PulToSearchControl is a subclass of UIRefreshControl. It can be added to UIScrollView directly as a UIRefreshControl. But instead of performing reload task, it helps performing search by making UISearchBar active.

# Requirement
+ iOS 9.0+
+ Swift 4.2

# Installation

### CocoaPods
#### 1. create Podfile
```ruby:Podfile
platform :ios, '9.0'
use_frameworks!

pod 'PullToSearchControl'
```

#### 2. install
```
> pod install
```

# Getting Started

It’s good to start by looking at the PullToSearchControlExample inside this Git repo.

## 1. Import PullToSearchControl in you class

```swift
import PullToSearchControl
```
## 2. Using PullToSearchControl as a UIRefreshControl
Don't forget to make your ViewController a delegate of PullToSearchControl

```swift
scrView.addSubview(pullToSearchControl)
pullToSearchControl.delegate = self
scrView.delegate = self
```


## 3. Call PullToSearchControl's methods on UIScrollView's events.
```swift
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pullToSearchControl.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullToSearchControl.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
}
```

## 4. And in the PullToSearchDelegate do whatever you want
```swift
extension ViewController: PullToSearchControlDelegate {
    func didFinishPull() {
        //For example: active your search bar
        //searchBar.becomeFirstResponder()
    }
}
```

## 5. Basically, your ViewController will look like this
```swift
import UIKit
import PullToSearchControl

class ViewController: UIViewController {
    @IBOutlet weak var scrView: UIScrollView!
    
    private lazy var pullToSearchControl = PullToSearchControl()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrView.addSubview(pullToSearchControl)
        pullToSearchControl.delegate = self
        scrView.delegate = self

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
    }
}

extension ViewController: PullToSearchControlDelegate {
    func didFinishPull() {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pullToSearchControl.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pullToSearchControl.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
}
```

# License

The MIT License (MIT)

Copyright (c) 2018 Yahoo Japan Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
