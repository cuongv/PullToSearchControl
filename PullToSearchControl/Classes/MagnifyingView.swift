//
//  MagnifyingView.swift
//  Today
//
//  Created by Cuong Vuong on 27/3/19.
//  Copyright © 2019 Cuong Vuong. All rights reserved.
//

import UIKit

final class MagnifyingView: UIView {
    private let fillColor = UIColor(red: 216.0 / 255, green: 66.0 / 255, blue: 70.0 / 255, alpha: 1.0)
    private var filledPercent: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
            let scale = filledPercent > 1 ? min(1.4, filledPercent) : 1.0
            transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let backgroundRadius = min(rect.width, rect.height) / 2

        //Draw filled part, which is red
        let filledAngle = acos(1 - 2 *  min(1.0, filledPercent))
        let filledPath = UIBezierPath(arcCenter: CGPoint(x: backgroundRadius, y: backgroundRadius),
                            radius: backgroundRadius,
                            startAngle: .pi / 2 - filledAngle,
                            endAngle: .pi / 2 + filledAngle,
                            clockwise: true)
        fillColor.setFill()
        filledPath.fill()

        //Draw magnify: Here we only need to do simple math to check the magnify is filled by red color or not, and make the filled parts white
        let filledPartY = 2 * backgroundRadius * (1 - filledPercent)
        let circleRadius = backgroundRadius / 2.5
        let circleCenter = CGPoint(x: backgroundRadius / 2 + circleRadius, y: backgroundRadius / 2 + circleRadius)
        
        let cos = (filledPartY - circleCenter.y) / circleRadius
        var magnifyAngle: CGFloat
        if cos >= 1 {
            magnifyAngle = -2 * .pi
        } else if cos <= -1 {
            magnifyAngle = 2 * .pi
        } else {
            magnifyAngle = acos(cos)
        }
        
        //Upper part of magnify, which is not filled
        let upperPath = UIBezierPath(arcCenter: CGPoint(x: circleCenter.x, y: circleCenter.y),
                                     radius: circleRadius,
                                     startAngle: .pi / 2 + magnifyAngle,
                                     endAngle: .pi / 2 - magnifyAngle,
                                     clockwise: true)
        upperPath.lineWidth = backgroundRadius / 10
        UIColor.lightGray.setStroke()
        upperPath.stroke()
        
        //Lower part of magnify, which is filled
        let lowerPath = UIBezierPath(arcCenter: CGPoint(x: circleCenter.x, y: circleCenter.y),
                                     radius: circleRadius,
                                     startAngle: .pi / 2 - magnifyAngle,
                                     endAngle: .pi / 2 + magnifyAngle,
                                     clockwise: true)
        lowerPath.lineWidth = backgroundRadius / 10
        UIColor.white.setStroke()
        lowerPath.stroke()

        //Draw the hand
        let upperPointMagnify = CGPoint(x: backgroundRadius * 1.2, y: backgroundRadius * 1.2)
        let lowerPointMagnify = CGPoint(x: backgroundRadius * 1.5, y: backgroundRadius * 1.5)
        var intersectPoint: CGPoint
        
        if filledPartY <= upperPointMagnify.y {
            intersectPoint = upperPointMagnify
        } else if filledPartY >= lowerPointMagnify.y {
            intersectPoint = lowerPointMagnify
        } else {
            let tan = (lowerPointMagnify.y - upperPointMagnify.y) / (lowerPointMagnify.x - upperPointMagnify.x)
            let deltaY = filledPartY - upperPointMagnify.y
            let deltaX = deltaY / tan
            intersectPoint = CGPoint(x: upperPointMagnify.x + deltaX, y: filledPartY)
        }
        
        //Upper part of the hand, which is not filled
        let notFilledLine = UIBezierPath()
        notFilledLine.lineWidth = backgroundRadius / 10
        notFilledLine.lineCapStyle = .round
        notFilledLine.move(to: upperPointMagnify)
        UIColor.lightGray.setStroke()
        notFilledLine.addLine(to: intersectPoint)
        notFilledLine.stroke()
        
        //Lower part of the hand, which is filled
        let filedLine = UIBezierPath()
        filedLine.lineWidth = backgroundRadius / 10
        filedLine.lineCapStyle = .round
        filedLine.move(to: intersectPoint)
        UIColor.white.setStroke()
        filedLine.addLine(to: lowerPointMagnify)
        filedLine.stroke()
    }
    
    func setFilledPercent(_ percent: CGFloat) {
        filledPercent = max(0, percent)
    }
}

