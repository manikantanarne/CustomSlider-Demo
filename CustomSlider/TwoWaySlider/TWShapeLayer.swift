//
//  TWShapeLayer.swift
//  CustomSlider
//
//  Created by Nagmanikantha on 06/02/20.
//  Copyright © 2020 Josh Software. All rights reserved.
//

import UIKit

class TWThumbShapeLayer: CALayer {
    
    public var isMoving:Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var slider: TwoWaySlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = slider else {
            return
        }
        
        let shapeFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
        let cornerRadius = shapeFrame.height
        let thumbPath = UIBezierPath(roundedRect: shapeFrame, cornerRadius: cornerRadius)
        
        // Fill
        ctx.setFillColor(slider.thumbTintColor.cgColor)
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
        
        // Outline
        ctx.setStrokeColor(slider.thumbBorderColor.cgColor)
        ctx.setLineWidth(slider.thumbBorderWidth)
        ctx.addPath(thumbPath.cgPath)
        ctx.strokePath()
        
        if isMoving {
            ctx.setFillColor(UIColor(white: 0.0, alpha: 0.3).cgColor)
            ctx.addPath(thumbPath.cgPath)
            ctx.fillPath()
        }
    }
}



class TWTrackShapeLayer: CALayer {
    
    weak var slider:TwoWaySlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = slider else {
            return
        }
        
        let cornerRadius = bounds.height
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        let lowerValuePosition = CGFloat(slider.positionForThumb(For: slider.lowerValue))
        let upperValuePosition = CGFloat(slider.positionForThumb(For: slider.upperValue))
        
        if let startColor = slider.gradientStartColor, let endColor = slider.gradientEndColor {
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            if let startColorComponents = startColor.cgColor.components, let endColorComponents = endColor.cgColor.components {
                
                let colorComponents = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
                
                let locations:[CGFloat] = [0.0, 1.0]
                
                if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 2) {
                    
                    let startPoint = CGPoint(x: lowerValuePosition, y: bounds.height)
                    let endPoint = CGPoint(x: upperValuePosition, y: bounds.height)
                    
                    ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
                }else {
                    ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
                    let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
                    ctx.fill(rect)
                }
            }else {
                ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
                let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
                ctx.fill(rect)
            }
        }else {
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
            ctx.fill(rect)
        }
        
    }
}
