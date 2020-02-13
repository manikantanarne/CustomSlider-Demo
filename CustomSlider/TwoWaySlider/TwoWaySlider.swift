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
        if value <= 110 {
            let currentValue = value - 10
            let width = trackWidth*0.25
            let stepSize = width/100
            let stepsMoved = currentValue/1
            let positionMovedTo =  stepsMoved * stepSize
            return positionMovedTo
        }else if value > 110 && value <= 250 {
            let currentValue = value - 110
            let previousSectionWidth = trackWidth*0.25
            let currentSectionWidth = trackWidth*0.175
            let stepSize = currentSectionWidth/70
            let stepsMoved = currentValue/2
            let positionMovedTo = stepsMoved * stepSize
            return positionMovedTo + previousSectionWidth
        }else if value > 250 && value <= 1000 {
            let currentValue = value - 250
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175
            let currentSectionWidth = trackWidth*0.375
            let stepSize = currentSectionWidth/150
            let stepsMoved = currentValue/5
            let positionMovedTo = stepsMoved * stepSize
            return positionMovedTo + previousSectionsWidth
        }else {
            let currentValue = value - 1000
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175 + trackWidth*0.375
            let currentSectionWidth = trackWidth - previousSectionsWidth
            let stepSize = currentSectionWidth/90
            let stepsMoved = currentValue/100
            let positionMovedTo = stepsMoved * stepSize
            return positionMovedTo + previousSectionsWidth
        }
    }
    
    private func calculateValue(At position:CGPoint) -> CGFloat {
        let trackWidth = bounds.width - thumbWidth
        let xPosition = position.x - thumbWidth/2
        if xPosition <= trackWidth*0.25 {
            let width = trackWidth*0.25
            let stepSize = width/100
            let positionMovedTo = width - xPosition
            let value = 10 + (100 - (positionMovedTo/stepSize))
            print("value1-----> \(value)")
            return value
        }else if xPosition > trackWidth*0.25 && xPosition <= (trackWidth*0.25 + trackWidth*0.175) {
            let previousSectionWidth = trackWidth*0.25
            let currentSectionWidth = trackWidth*0.175
            let stepSize = currentSectionWidth/70
            let positionMovedTo = xPosition - previousSectionWidth
            let stepsMoved = positionMovedTo/stepSize
            let stepsValue = stepsMoved * 2
            var value = 110 + stepsValue
            
            if Int(value)%2 != 0 {
                value = CGFloat((Int(value)/2)*2)
            }
            
            print("value2-----> \(value)")
            return value
            
        }else if xPosition > (trackWidth*0.25 + trackWidth*0.175) && xPosition <= (trackWidth*0.25 + trackWidth*0.175 + trackWidth*0.375) {
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175
            let currentSectionWidth = trackWidth*0.375
            let stepSize = currentSectionWidth/150
            let positionMovedTo = xPosition - previousSectionsWidth
            let stepsMoved = positionMovedTo/stepSize
            let stepsValue = stepsMoved * 5
            var value = 250 + stepsValue
            if Int(value)%5 != 0 {
                value = CGFloat((Int(value)/5)*5)
            }
            print("value3-----> \(value)")
            return value
            
        }else {
            let previousSectionsWidth = trackWidth*0.25 + trackWidth*0.175 + trackWidth*0.375
            let currentSectionWidth = trackWidth - previousSectionsWidth
            let stepSize = currentSectionWidth/90
            let positionMovedTo = xPosition - previousSectionsWidth
            let stepsMoved = positionMovedTo/stepSize
            let stepsValue = stepsMoved * 100
            var value = 1000 + stepsValue
            if Int(value)%100 != 0 {
                value = CGFloat((Int(value)/100) * 100)
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
