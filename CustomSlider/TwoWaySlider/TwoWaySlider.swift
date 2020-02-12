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
    @objc optional func positionChangesForThumbs(minThumbPosition:CGPoint, maxThumbPosition:CGPoint, isMinThumbMoving:Bool, isMaxThumbMoving:Bool)
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
            outputLowerValue = lowerValue/(bounds.width/bounds.height)
            updateLayerFrames()
        }
    }
    
    public var upperValue: CGFloat = 0.8 {
        didSet {
            if upperValue > maximumValue {
                upperValue = maximumValue
            }
            outputUpperValue = upperValue/(bounds.width/bounds.height)
            updateLayerFrames()
        }
    }
    
    public weak var delegate:TwoWaySliderProtocol?
    
    public var thumbTintColor:UIColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    public var thumbBorderColor:UIColor = UIColor.lightGray
    public var thumbBorderWidth:CGFloat = 2
    public var trackHeight:CGFloat = 2
    public var trackTintColor:UIColor = UIColor.lightGray
    public var trackHighlightTintColor:UIColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
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
    
    private var outputLowerValue:CGFloat!
    private var outputUpperValue:CGFloat!
    
    private var widthMultiplier:CGFloat {
        if (10...110).contains(upperValue) {
            return 5
        }else if (111...250).contains(upperValue) {
            return 4
        }else if (251...1000).contains(upperValue) {
            return 2
        }else {
            return 0.10
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
        
        trackLayer.frame = CGRect(x: thumbWidth/2, y: thumbWidth/2 - trackHeight/2, width: bounds.width - thumbWidth, height: trackHeight)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        shapeLayerMin.frame = CGRect(x: lowerThumbCenter, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        shapeLayerMin.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        shapeLayerMax.frame = CGRect(x: upperThumbCenter, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        shapeLayerMax.setNeedsDisplay()
        
        CATransaction.commit()
        
        delegate?.positionChangesForThumbs?(minThumbPosition: CGPoint(x: shapeLayerMin.frame.minX + frame.minX + thumbWidth/2, y: frame.minY - frame.size.height/2 - thumbWidth/2), maxThumbPosition: CGPoint(x: shapeLayerMax.frame.minX + frame.minX + thumbWidth/2, y: frame.minY - frame.size.height/2 - thumbWidth/2), isMinThumbMoving: shapeLayerMin.isMoving, isMaxThumbMoving: shapeLayerMax.isMoving)
    }
    
    // get position for the thumb according to value
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return (bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) //+ (thumbWidth/2.0)
    }
    
    // bound value with lower and upper values
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        let bound = min(max(value, lowerValue), upperValue)
//        print("bound-----> \(bound)")
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
//        print("deltaPoints-----> \(deltaPoints)")
        let deltaValue = (maximumValue - minimumValue) * deltaPoints/(bounds.width - bounds.height)
//        print("deltaValue-----> \(deltaValue)")
        previousPoint = position
        
        if shapeLayerMin.isMoving == true {
            lowerValue = boundValue(lowerValue + deltaValue, toLowerValue: minimumValue, upperValue: upperValue - gapBetweenThumbs)
//            calculation()
        }else if shapeLayerMax.isMoving == true {
            upperValue = boundValue(upperValue + deltaValue, toLowerValue: lowerValue + gapBetweenThumbs, upperValue: maximumValue)
        }
        
        outputLowerValue = lowerValue//getSelectedLowerValue(value: lowerValue)
//        print("outputLowerValue-----> \(String(describing: outputLowerValue))")
        outputUpperValue = upperValue//getSelectedUpperValue(value: upperValue)
//        print("outputUpperValue-----> \(String(describing: outputUpperValue))")
        
        delegate?.sliderValueChanges(lowerValue: Double(outputLowerValue), upperValue: Double(outputUpperValue))
        
        return true
    }
    
    private func getSelectedLowerValue(value:CGFloat) -> CGFloat {
        let actualPosition = shapeLayerMin.position.x - thumbWidth/2
        if Int(outputLowerValue) < 110/*actualPosition < (bounds.width * 0.25)*/ {
            print("value -----> \(value)")
            print("exact-----> \(value/(bounds.width/bounds.height))")
            print("addition-----> \(value/(bounds.width/bounds.height))")
            return (value/(bounds.width/bounds.height))
//            return lowerValue - ((bounds.width/bounds.height) - 1)
        }else if (110..<250).contains(Int(outputLowerValue))/*actualPosition > (bounds.width * 0.25) && actualPosition < (bounds.width * 0.25 + bounds.width * 0.175)*/ {
            print("value -----> \(value)")
            print("exact-----> \(value/(bounds.width/bounds.height))")
            print("addition-----> \((value + (bounds.width/bounds.height))/(bounds.width/bounds.height))")
            return (value + (bounds.width/bounds.height))/(bounds.width/bounds.height)
        }else if (250..<1000).contains(outputLowerValue)/*actualPosition > (bounds.width * 0.25 + bounds.width * 0.175) && actualPosition < (bounds.width * 0.25 + bounds.width * 0.175 + bounds.width * 0.375)*/ {
            return (value/(bounds.width/bounds.height)) + 5
        }else {
            return (value/(bounds.width/bounds.height)) + 100
        }
    }
    
    private func getSelectedUpperValue(value:CGFloat) -> CGFloat {
        let actualPosition = shapeLayerMax.position.x - thumbWidth/2
        if actualPosition < (bounds.width * 0.25) {
//            return closestNumber(n: (value/(bounds.width/bounds.height)), m: 1)
            return closestNumber(n: 100 * actualPosition/(bounds.width * 0.25), m: 1)
        }else if actualPosition > (bounds.width * 0.25) && actualPosition < (bounds.width * 0.25 + bounds.width * 0.175) {
//            return closestNumber(n: (value/(bounds.width/bounds.height)) * 2, m: 2)
            return closestNumber(n: 70 * actualPosition/((bounds.width * 0.25) + (bounds.width * 0.175)), m: 2)
        }else if actualPosition > (bounds.width * 0.25 + bounds.width * 0.175) && actualPosition < (bounds.width * 0.25 + bounds.width * 0.175 + bounds.width * 0.375) {
//            return closestNumber(n: (value/(bounds.width/bounds.height)) * 5, m: 5)
            return closestNumber(n: 150 * actualPosition/((bounds.width * 0.25) + (bounds.width * 0.175) + (bounds.width * 0.375)), m: 5)
        }else {
//            return closestNumber(n: (value/(bounds.width/bounds.height)) * 100, m: 100)
            return closestNumber(n: 90 * actualPosition/bounds.width, m: 100)
        }
    }
    
//    private func getNumberForSecondStep(value:CGFloat) -> CGFloat {
//        if value > 110 {
//            if value.truncatingRemainder(dividingBy: 2) == 0 {
//                return
//            }else {
//                return value + 1
//            }
//        }
//    }
    
    private func closestNumber(n: CGFloat, m: CGFloat) -> CGFloat { // find the quotient
        let q = n / m
        // 1st possible closest number
        let n1 = m * q
        // 2nd possible closest number
        let n2 = (n * m > 0) ? m * (q + 1) : m * (q - 1)
        // if true, then n1 is the required closest number
        return (abs(n - n1) < abs(n - n2)) ? n1 : n2
        // else n2 is the required closest number
    }
    
    func calculation() {
        
        let multiplier = bounds.width/410
        if (shapeLayerMin.position.x - thumbWidth/2) < bounds.width*0.25 {
            let value = (shapeLayerMin.position.x - thumbWidth/2)/(multiplier*100)
            print("value-----> \(value)")
        }
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        shapeLayerMin.isMoving = false
        shapeLayerMax.isMoving = false
    }
}
