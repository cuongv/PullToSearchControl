//
//  ViewController.swift
//  PullToSearchControlExample
//
//  Created by Cuong Vuong on 29/3/19.
//  Copyright © 2019 i3. All rights reserved.
//

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

