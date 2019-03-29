//
//  PullToSearchControl.swift
//  Today
//
//  Created by Cuong Vuong on 27/3/19.
//  Copyright © 2019 Cuong Vuong. All rights reserved.
//

import UIKit

protocol PullToSearchControlDelegate: AnyObject {
    func didFinishPull()
}

final class PullToSearchControl: UIRefreshControl {
    private lazy var magnifingView = MagnifyingView()
    
    private let finishOffset: CGFloat = 120
    private let delayOffset: CGFloat = 20
    private let magniSize: CGFloat  = 45
    
    private var isRunningAnimation = false
    private var lastOffset: CGFloat = 0
    
    weak var delegate: PullToSearchControlDelegate?

    override init() {
        super.init()
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        tintColor = .clear

        if let contentView = subviews.first {
            magnifingView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(magnifingView)
            NSLayoutConstraint.activate([
                magnifingView.widthAnchor.constraint(equalToConstant: magniSize),
                magnifingView.heightAnchor.constraint(equalToConstant: magniSize),
                magnifingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                magnifingView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 18)
            ])
        }
    }
    
    private func animateMagnify() {
        isRunningAnimation = true
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.magnifingView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self?.magnifingView.alpha = 0.1
        }, completion: { [weak self] _ in
            self?.magnifingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self?.magnifingView.alpha = 1.0
            self?.magnifingView.isHidden = true
            self?.isRunningAnimation = false
            self?.delegate?.didFinishPull()
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isRunningAnimation && scrollView.contentOffset.y < 0 else { return }
        
        //Re-display magnify when scrolling down only
        if scrollView.contentOffset.y < lastOffset {
            magnifingView.isHidden = false
        }
        magnifingView.setFilledPercent((abs(scrollView.contentOffset.y) - delayOffset) / finishOffset)
        lastOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !isRunningAnimation && scrollView.contentOffset.y < 0 else { return }

        //Drag over the finish offset and release
        if -1 * scrollView.contentOffset.y > finishOffset {
            animateMagnify()
        }
        endRefreshing()
    }
}

