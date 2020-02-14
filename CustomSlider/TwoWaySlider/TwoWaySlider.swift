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
//            outputLowerValue = lowerValue///(bounds.width/bounds.height)
            updateLayerFrames()
        }
    }
    
    public var upperValue: CGFloat = 0.8 {
        didSet {
            if upperValue > maximumValue {
                upperValue = maximumValue
            }
//            outputUpperValue = upperValue///(bounds.width/bounds.height)
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
        updateLayerFrames()
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
        

        let lowerThumbCenter = positionForThumb(For: lowerValue)//CGFloat(positionForValue(lowerValue))
        shapeLayerMin.frame = CGRect(x: lowerThumbCenter, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        shapeLayerMin.setNeedsDisplay()
        
        let upperThumbCenter = positionForThumb(For: upperValue)//CGFloat(positionForValue(upperValue))
        shapeLayerMax.frame = CGRect(x: upperThumbCenter, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        shapeLayerMax.setNeedsDisplay()
        
        CATransaction.commit()
        
        delegate?.positionChangesForThumbs?(minThumbPosition: CGPoint(x: shapeLayerMin.frame.minX + frame.minX + thumbWidth/2, y: frame.minY - frame.size.height/2 - thumbWidth/2), maxThumbPosition: CGPoint(x: shapeLayerMax.frame.minX + frame.minX + thumbWidth/2, y: frame.minY - frame.size.height/2 - thumbWidth/2), isMinThumbMoving: shapeLayerMin.isMoving, isMaxThumbMoving: shapeLayerMax.isMoving)
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
        
        return shapeLayerMin.isMoving || shapeLayerMax.isMoving
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let position = touch.location(in: self)
        
        if shapeLayerMin.isMoving == true {
            if position.x >= thumbWidth/2 && position.x <= (bounds.width - thumbWidth/2) && position.x <= shapeLayerMax.position.x {
                lowerValue = calculateValue(At: position)
                lowerValue = (lowerValue < minimumValue) ? minimumValue : lowerValue
            }
        }else if shapeLayerMax.isMoving == true {
            if position.x <= (bounds.width - thumbWidth/2) && position.x >= thumbWidth/2 && position.x >= shapeLayerMin.position.x {
                upperValue = calculateValue(At: position)
                upperValue = (upperValue > maximumValue) ? maximumValue : upperValue
            }
        }
        
        delegate?.sliderValueChanges(lowerValue: Double(lowerValue), upperValue: Double(upperValue))
        return true
    }
    
    internal func positionForThumb(For value:CGFloat) -> CGFloat {
        let trackWidth = bounds.width - thumbWidth
        
        let rangeMultiplier:Int = (minimumValue > 10) ? Int(minimumValue)/10 : 1
        
        if value <= (110 * CGFloat(rangeMultiplier)) {
            
            let currentValue = value - minimumValue
            var currentSectionSteps:CGFloat = 100
            let additionalSteps = (minimumValue < (10 * CGFloat(rangeMultiplier))) ? (10 * CGFloat(rangeMultiplier)) - minimumValue : 0
            currentSectionSteps += additionalSteps
            let width = trackWidth*0.25
            let stepSize = width/currentSectionSteps
            let stepsMoved = currentValue/(1 * CGFloat(rangeMultiplier))
            let positionMovedTo =  stepsMoved * stepSize
            
            return positionMovedTo
            
        }else if value > (110 * CGFloat(rangeMultiplier)) && value <= (250 * CGFloat(rangeMultiplier)) {
            
            let currentValue = value - (110 * CGFloat(rangeMultiplier))
            let previousSectionWidth = trackWidth*0.25
            let currentSectionWidth = trackWidth*0.175
            let currentSectionSteps:CGFloat = 70
            let stepSize = currentSectionWidth/currentSectionSteps
            let stepsMoved = currentValue/(2 * CGFloat(rangeMultiplier))
            let positionMovedTo = stepsMoved * stepSize
            
            return positionMovedTo + previousSectionWidth
            
        }else if value > (250 * CGFloat(rangeMultiplier)) && value <= (1000 * CGFloat(rangeMultiplier)) {
            
            let currentValue = value - (250 * CGFloat(rangeMultiplier))
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175
            let currentSectionWidth = trackWidth*0.375
            let currentSectionSteps:CGFloat = 150
            let stepSize = currentSectionWidth/currentSectionSteps
            let stepsMoved = currentValue/(5 * CGFloat(rangeMultiplier))
            let positionMovedTo = stepsMoved * stepSize
            
            return positionMovedTo + previousSectionsWidth
            
        }else {
            
            let currentValue = value - (1000 * CGFloat(rangeMultiplier))
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175 + trackWidth*0.375
            let currentSectionWidth = trackWidth - previousSectionsWidth
            let currentSectionSteps:CGFloat = 90
            let stepSize = currentSectionWidth/currentSectionSteps
            let stepsMoved = currentValue/(100 * CGFloat(rangeMultiplier))
            let positionMovedTo = stepsMoved * stepSize
            
            return positionMovedTo + previousSectionsWidth
        }
    }
    
    private func calculateValue(At position:CGPoint) -> CGFloat {
        
        let rangeMultiplier:Int = (minimumValue > 10) ? Int(minimumValue)/10 : 1
        
        let trackWidth = bounds.width - thumbWidth
        let xPosition = position.x - thumbWidth/2
        
        if xPosition <= trackWidth*0.25 {
            
            let currentSectionWidth = trackWidth*0.25
            var currentSectionSteps:CGFloat = 100
            let additionalSteps = (minimumValue < 10*CGFloat(rangeMultiplier)) ? (10*CGFloat(rangeMultiplier)) - minimumValue : 0
            currentSectionSteps += additionalSteps
            let stepSize = currentSectionWidth/currentSectionSteps
            let positionMovedTo = xPosition - 0
            let stepsMoved = positionMovedTo/stepSize
            print("stepsMoved-----> \(Int(stepsMoved))")
            let stepsValue = Int(stepsMoved) * (1 * rangeMultiplier)
            let value = minimumValue + CGFloat(stepsValue)
//            print("value1-----> \(value)")
            
            return value
            
        }else if xPosition > trackWidth*0.25 && xPosition <= (trackWidth*0.25 + trackWidth*0.175) {
            
            let previousSectionWidth = trackWidth*0.25
            let currentSectionWidth = trackWidth*0.175
            let currentSectionSteps:CGFloat = 70
            let stepSize = currentSectionWidth/currentSectionSteps
            let positionMovedTo = xPosition - previousSectionWidth
            let stepsMoved = positionMovedTo/stepSize
            let stepMultiplier = (2 * rangeMultiplier)
            let stepsValue = Int(stepsMoved) * stepMultiplier
            var value = (110 * CGFloat(rangeMultiplier)) + CGFloat(stepsValue)
            
            if Int(value)%stepMultiplier != 0 {
                value = CGFloat((Int(value)/stepMultiplier)*stepMultiplier)
            }
            
//            print("value2-----> \(value)")
            
            return value
            
        }else if xPosition > (trackWidth*0.25 + trackWidth*0.175) && xPosition <= (trackWidth*0.25 + trackWidth*0.175 + trackWidth*0.375) {
            
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175
            let currentSectionWidth = trackWidth*0.375
            let currentSectionSteps:CGFloat = 150
            let stepSize = currentSectionWidth/currentSectionSteps
            let positionMovedTo = xPosition - previousSectionsWidth
            let stepsMoved = positionMovedTo/stepSize
            let stepMultiplier = (5 * rangeMultiplier)
            let stepsValue = Int(stepsMoved) * stepMultiplier
            var value = (250 * CGFloat(rangeMultiplier)) + CGFloat(stepsValue)
            if Int(value)%stepMultiplier != 0 {
                value = CGFloat((Int(value)/stepMultiplier)*stepMultiplier)
            }
            print("value3-----> \(value)")
            
            return value
            
        }else {
            
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175 + trackWidth*0.375
            let currentSectionWidth = trackWidth - previousSectionsWidth
            let currentSectionSteps:CGFloat = 90
            let stepSize = currentSectionWidth/currentSectionSteps
            let positionMovedTo = xPosition - previousSectionsWidth
            let stepsMoved = positionMovedTo/stepSize
            let stepMultiplier = (100 * rangeMultiplier)
            let stepsValue = Int(stepsMoved) * stepMultiplier
            var value = (1000 * CGFloat(rangeMultiplier)) + CGFloat(stepsValue)
            if Int(value)%stepMultiplier != 0 {
                value = CGFloat((Int(value)/stepMultiplier) * stepMultiplier)
            }
            print("value4-----> \(value)")
            return value
        }
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        shapeLayerMin.isMoving = false
        shapeLayerMax.isMoving = false
    }
}
