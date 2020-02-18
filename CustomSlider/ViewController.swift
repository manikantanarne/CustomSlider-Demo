//
//  ViewController.swift
//  CustomSlider
//
//  Created by Nagmanikantha on 05/02/20.
//  Copyright © 2020 Josh Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let slider = TwoWaySlider(frame: .zero)
    let lowerValueLbl = UILabel()
    let upperValueLbl = UILabel()
    var sliderLowerValue:CGFloat = 100.0
    var sliderUpperValue:CGFloat = 1000.0
    var previousMinPosition:CGFloat?
    var previousMaxPosition:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Customize and add slider
       
        slider.backgroundColor = UIColor.clear
        slider.minimumValue = 10.0
        slider.maximumValue = 10000.0
        slider.lowerValue = sliderLowerValue
        slider.upperValue = sliderUpperValue
        slider.thumbBorderWidth = 1.5
        slider.thumbBorderColor = UIColor.lightGray
        slider.thumbTintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        slider.trackHeight = 5.0
        slider.trackTintColor = UIColor.lightGray
        slider.trackHighlightTintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        slider.delegate = self
        
        view.addSubview(slider)
        
        //add labels
        lowerValueLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        lowerValueLbl.text = "\(Int(sliderLowerValue))"
        lowerValueLbl.textColor = UIColor.black
        lowerValueLbl.textAlignment = .center
        lowerValueLbl.font = UIFont.systemFont(ofSize: 11.0)
        lowerValueLbl.backgroundColor = UIColor.lightGray
        lowerValueLbl.layer.cornerRadius = 5
        lowerValueLbl.clipsToBounds = true

        view.addSubview(lowerValueLbl)

        upperValueLbl.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        upperValueLbl.text = "\(Int(sliderUpperValue))"
        upperValueLbl.textColor = UIColor.black
        upperValueLbl.textAlignment = .center
        upperValueLbl.font = UIFont.systemFont(ofSize: 11.0)
        upperValueLbl.backgroundColor = UIColor.lightGray
        upperValueLbl.layer.cornerRadius = 5
        upperValueLbl.clipsToBounds = true

        view.addSubview(upperValueLbl)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20
        let width = view.bounds.width - 2 * margin
        let height: CGFloat = 40
        
        slider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        slider.center = view.center
    }


}


extension ViewController:TwoWaySliderProtocol {
    func sliderValueChanges(lowerValue: Double, upperValue: Double) {
        sliderLowerValue = CGFloat(lowerValue)
        sliderUpperValue = CGFloat(upperValue)
        lowerValueLbl.text = "\(Int(lowerValue))"
        upperValueLbl.text = "\(Int(upperValue))"
    }
    
    func positionChangesForThumbs(minThumbPosition: CGPoint, maxThumbPosition: CGPoint, isMinThumbMoving:Bool, isMaxThumbMoving:Bool) {
        
        lowerValueLbl.frame.size.width = lowerValueLbl.intrinsicContentSize.width + 5
        upperValueLbl.frame.size.width = upperValueLbl.intrinsicContentSize.width + 5
        
        
        let frameLowerLbl = CGRect(x: (minThumbPosition.x - lowerValueLbl.frame.size.width/2), y: lowerValueLbl.frame.origin.y, width: lowerValueLbl.frame.size.width, height: lowerValueLbl.frame.size.height)
        let frameUpperLbl = CGRect(x: (maxThumbPosition.x - upperValueLbl.frame.size.width/2), y: upperValueLbl.frame.origin.y, width: upperValueLbl.frame.size.width, height: upperValueLbl.frame.size.height)
        
        if isMinThumbMoving == true {
            
            if frameLowerLbl.minX > slider.frame.minX {
                
                if frameLowerLbl.intersects(frameUpperLbl) {
                    if (frameLowerLbl.maxX + frameUpperLbl.size.width) < slider.frame.maxX {
                        if (maxThumbPosition.x - minThumbPosition.x) > 20 {
                            upperValueLbl.frame.origin.x = frameLowerLbl.maxX
                            lowerValueLbl.center.x = minThumbPosition.x
                        }else {
                            if let positionMax = previousMaxPosition, let positionMin = previousMinPosition {
                                lowerValueLbl.center.x = positionMin
                                upperValueLbl.center.x = positionMax
                            }
                        }
                    }else {
                        if let positionMin = previousMinPosition, let positionMax = previousMaxPosition {
                            lowerValueLbl.center.x = positionMin
                            upperValueLbl.center.x = positionMax
                        }
                    }
                }else {
                    lowerValueLbl.center.x = minThumbPosition.x
                }
                
            }else {
                if let positionMin = previousMinPosition {
                    lowerValueLbl.center.x = positionMin
                }
            }
        }else if isMaxThumbMoving == true {
            
            if frameUpperLbl.maxX < slider.frame.maxX {
                
                if frameUpperLbl.intersects(frameLowerLbl) {
                    
                    if (frameUpperLbl.minX - lowerValueLbl.frame.size.width) > slider.frame.minX {
                        
                        if (maxThumbPosition.x - minThumbPosition.x) > 20 {
                            lowerValueLbl.frame.origin.x = (frameUpperLbl.minX - lowerValueLbl.frame.size.width)
                            upperValueLbl.center.x = maxThumbPosition.x
                        }else {
                            if let positionMax = previousMaxPosition, let positionMin = previousMinPosition {
                                lowerValueLbl.center.x = positionMin
                                upperValueLbl.center.x = positionMax
                            }
                        }
                        
                        
                    }else {
                        if let positionMax = previousMaxPosition, let positionMin = previousMinPosition {
                            lowerValueLbl.center.x = positionMin
                            upperValueLbl.center.x = positionMax
                        }
                    }
                }else {
                    upperValueLbl.center.x = maxThumbPosition.x
                }
                
            }else {
                if let positionMax = previousMaxPosition {
                    upperValueLbl.center.x = positionMax
                }
            }
        }else {
            lowerValueLbl.center.x = minThumbPosition.x
            upperValueLbl.center.x = maxThumbPosition.x
            lowerValueLbl.center.y = minThumbPosition.y
            upperValueLbl.center.y = maxThumbPosition.y
        }
 
        previousMinPosition = lowerValueLbl.center.x
        previousMaxPosition = upperValueLbl.center.x
    }
}

