//
//  CircularProgressView.swift
//  Home
//
//  Created by Reza Mac on 21/09/24.
//

import UIKit

class CircularProgressView: UIView {
    private var shapeLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    
    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                         radius: bounds.width / 2 - 5,
                                         startAngle: -CGFloat.pi / 2,
                                         endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                         clockwise: true)

        shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 5
        layer.addSublayer(shapeLayer)

        progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = 5
        progressLayer.strokeEnd = 0 // Initially 0
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                        radius: bounds.width / 2 - 5,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                        clockwise: true).cgPath
        progressLayer.path = shapeLayer.path
    }
}
