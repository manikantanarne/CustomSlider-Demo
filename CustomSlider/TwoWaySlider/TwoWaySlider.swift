//
//  TwoWaySlider.swift
//  CustomSlider
//
//  Created by Nagmanikantha on 05/02/20.
//  Copyright © 2020 Josh Software. All rights reserved.
//

import UIKit

@objc protocol TwoWaySliderProtocol {
    func sliderValueChanges(lowerValue:Double, upperValue:Double)
}

class TwoWaySlider: UIControl {
    
    //MARK: Public variables
    public var minimumValue: CGFloat = 0.0
    public var maximumValue: CGFloat = 1.0
    
    public var lowerValue: CGFloat = 0.2 {
        didSet {
            if lowerValue < minimumValue {
                lowerValue = minimumValue
            }
            updateLayerFrames()
        }
    }
    
    public var upperValue: CGFloat = 0.8 {
        didSet {
            if upperValue > maximumValue {
                upperValue = maximumValue
            }
            updateLayerFrames()
        }
    }
    
    public weak var delegate:TwoWaySliderProtocol?
    
    public var thumbColor:UIColor = UIColor.red
    public var thumbStrokeColor:UIColor = UIColor.black
    public var thumbStrokeWidth:CGFloat = 2
    public var rangeLineHeight:CGFloat = 2
    public var rangeLineColor:UIColor = UIColor.lightGray
    public var rangeLineHighlightColor:UIColor = UIColor.blue
    
    //MARK: Private variables
    private var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    private var gapBetweenThumbs: CGFloat {
        return 0//1.0 * CGFloat(thumbWidth) * (maximumValue - minimumValue) / CGFloat(bounds.width)
    }
    
    private let trackLayer = TWTrackShapeLayer()
    private let shapeLayerMin = TWThumbShapeLayer()
    private let shapeLayerMax = TWThumbShapeLayer()
    private var previousPoint = CGPoint()
    
    private var additionalComponentToLowerValue: CGFloat {
        if (CGFloat(0)...CGFloat(1000)).contains(lowerValue) {
            return CGFloat(5)
        }else if (CGFloat(1001)...CGFloat(4000)).contains(lowerValue) {
            return CGFloat(50)
        }else if (CGFloat(4001)...CGFloat(7000)).contains(lowerValue) {
            return CGFloat(100)
        }else {
            return CGFloat(500)
        }
    }
    
    private var additionalComponentToUpperValue: CGFloat {
        if (CGFloat(0)...CGFloat(1000)).contains(upperValue) {
            return CGFloat(5)
        }else if (CGFloat(1001)...CGFloat(4000)).contains(upperValue) {
            return CGFloat(50)
        }else if (CGFloat(4001)...CGFloat(7000)).contains(upperValue) {
            return CGFloat(100)
        }else {
            return CGFloat(500)
        }
    }
    
    
    override public var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initializeLayers()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeLayers()
    }
    
    override public func layoutSublayers(of: CALayer) {
        super.layoutSublayers(of:layer)
        updateLayerFrames()
    }
    
    // Initialize track and thumb layers
    private func initializeLayers() {
        
        trackLayer.slider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        shapeLayerMin.slider = self
        shapeLayerMin.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(shapeLayerMin)
        
        shapeLayerMax.slider = self
        shapeLayerMax.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(shapeLayerMax)
    }
    
    // Update track and thumb layer frames
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = CGRect(x: thumbWidth/2, y: thumbWidth/2 - rangeLineHeight/2, width: bounds.width - thumbWidth, height: rangeLineHeight)//bounds.insetBy(dx: 0.0, dy: bounds.height/3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        shapeLayerMin.frame = CGRect(x: lowerThumbCenter, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        shapeLayerMin.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        shapeLayerMax.frame = CGRect(x: upperThumbCenter, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        shapeLayerMax.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    // get position for the thumb according to value
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return (bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) //+ (thumbWidth/2.0)
    }
    
    // bound value with lower and upper values
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        let bound = min(max(value, lowerValue), upperValue)
        print("bound-----> \(bound)")
        return bound
    }
    
}

//MARK: Touches
extension TwoWaySlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        previousPoint = touch.location(in: self)
        
        let halfWidth = bounds.width/2
        
        if shapeLayerMax.frame.maxX > halfWidth && shapeLayerMin.frame.maxX > halfWidth {
            if shapeLayerMin.frame.contains(previousPoint) {
                shapeLayerMin.isMoving = true
                shapeLayerMax.isMoving = false
            }else if shapeLayerMax.frame.contains(previousPoint) {
                shapeLayerMax.isMoving = true
                shapeLayerMin.isMoving = false
            }
        }else {
            if shapeLayerMax.frame.contains(previousPoint) {
                shapeLayerMax.isMoving = true
                shapeLayerMin.isMoving = false
            }else if shapeLayerMin.frame.contains(previousPoint) {
                shapeLayerMin.isMoving = true
                shapeLayerMax.isMoving = false
            }
        }
        
        //        if shapeLayerMin.frame.contains(previousPoint) && shapeLayerMax.frame.contains(previousPoint) {
        //            shapeLayerMax.isMoving = true
        //            shapeLayerMin.isMoving = false
        //        }else if shapeLayerMin.frame.contains(previousPoint) {
        //
        //            shapeLayerMin.isMoving = true
        //            shapeLayerMax.isMoving = false
        //
        //        }else if shapeLayerMax.frame.contains(previousPoint) {
        //
        //            shapeLayerMax.isMoving = true
        //            shapeLayerMin.isMoving = false
        //        }
        
        return shapeLayerMin.isMoving || shapeLayerMax.isMoving
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let position = touch.location(in: self)
        
        let deltaPoints = position.x - previousPoint.x
        print("deltaPoints-----> \(deltaPoints)")
        let deltaValue = (maximumValue - minimumValue) * deltaPoints/(bounds.width - bounds.height)
        print("deltaValue-----> \(deltaValue)")
        previousPoint = position
        
        if shapeLayerMin.isMoving == true {
            lowerValue = boundValue(lowerValue + deltaValue, toLowerValue: minimumValue, upperValue: upperValue - gapBetweenThumbs)
        }else if shapeLayerMax.isMoving == true {
            upperValue = boundValue(upperValue + deltaValue, toLowerValue: lowerValue + gapBetweenThumbs, upperValue: maximumValue)
        }
        
        delegate?.sliderValueChanges(lowerValue: Double(lowerValue), upperValue: Double(upperValue))
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        shapeLayerMin.isMoving = false
        shapeLayerMax.isMoving = false
    }
}
