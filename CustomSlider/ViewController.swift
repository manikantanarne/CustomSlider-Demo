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
    var sliderMinValue:CGFloat = 10.0
    var sliderMaxValue:CGFloat = 10000.0
    var sliderLowerValue:CGFloat = 100.0
    var sliderUpperValue:CGFloat = 1000.0
    var previousMinPosition:CGFloat?
    var previousMaxPosition:CGFloat?
    
    let lowerValueLbl = UILabel()
    let upperValueLbl = UILabel()
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeSlider()
        initializeStackView()
        initializeLabels()
        
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20
        let width = view.bounds.width - 2 * margin
        let height: CGFloat = 40
        
        slider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        slider.center = view.center
        stackView.frame = CGRect(x: 0, y: slider.frame.maxY + 20, width: view.bounds.width , height: 35)
    }
    
    //MARK: Initialize and add slider
    func initializeSlider() {
        
        slider.removeFromSuperview()
        
        slider.backgroundColor = UIColor.clear
        slider.minimumValue = sliderMinValue
        slider.maximumValue = sliderMaxValue
        slider.lowerValue = sliderLowerValue
        slider.upperValue = sliderUpperValue
        slider.thumbBorderWidth = 1.5
        slider.thumbBorderColor = UIColor.black
        slider.thumbTintColor = UIColor.white
        slider.trackHeight = 5.0
        slider.trackTintColor = UIColor.lightGray
        slider.trackHighlightTintColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        slider.gradientStartColor = UIColor(red: 231.0/255.0, green: 210.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        slider.gradientEndColor = UIColor(red: 255.0/255.0, green: 57.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        slider.delegate = self
        
        view.addSubview(slider)
        
        slider.initializeSlider()
    }
    
    func initializeStackView() {
        
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 20.0
                
        let gbpBtn = UIButton(type: .system)
        gbpBtn.backgroundColor = UIColor.lightGray
        gbpBtn.setTitle("GBP", for: .normal)
        gbpBtn.setTitleColor(UIColor.white, for: .normal)
        gbpBtn.tag = 1
        gbpBtn.addTarget(self, action: #selector(actionOnCurrencyBtns(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(gbpBtn)
        
        let vesBtn = UIButton(type: .system)
        vesBtn.backgroundColor = UIColor.lightGray
        vesBtn.setTitle("VES", for: .normal)
        vesBtn.setTitleColor(UIColor.white, for: .normal)
        vesBtn.tag = 2
        vesBtn.addTarget(self, action: #selector(actionOnCurrencyBtns(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(vesBtn)
        
        let chfBtn = UIButton(type: .system)
        chfBtn.backgroundColor = UIColor.lightGray
        chfBtn.setTitle("CHF", for: .normal)
        chfBtn.setTitleColor(UIColor.white, for: .normal)
        chfBtn.tag = 3
        chfBtn.addTarget(self, action: #selector(actionOnCurrencyBtns(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(chfBtn)
        
        let inrBtn = UIButton(type: .system)
        inrBtn.backgroundColor = UIColor.lightGray
        inrBtn.setTitle("INR", for: .normal)
        inrBtn.setTitleColor(UIColor.white, for: .normal)
        inrBtn.tag = 4
        inrBtn.addTarget(self, action: #selector(actionOnCurrencyBtns(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(inrBtn)
        
        view.addSubview(stackView)
    }
    
    func initializeLabels() {
        
        lowerValueLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 28)
        lowerValueLbl.text = "\(Int(sliderLowerValue))"
        lowerValueLbl.textColor = UIColor.black
        lowerValueLbl.textAlignment = .center
        lowerValueLbl.font = UIFont.systemFont(ofSize: 11.0)
        lowerValueLbl.backgroundColor = UIColor.white
        lowerValueLbl.layer.cornerRadius = 14
        lowerValueLbl.layer.borderWidth = 1.0
        lowerValueLbl.layer.borderColor = UIColor.lightGray.cgColor
        lowerValueLbl.clipsToBounds = true

        view.addSubview(lowerValueLbl)

        upperValueLbl.frame = CGRect(x: 0, y: 0, width: 50, height: 28)
        upperValueLbl.text = "\(Int(sliderUpperValue))"
        upperValueLbl.textColor = UIColor.black
        upperValueLbl.textAlignment = .center
        upperValueLbl.font = UIFont.systemFont(ofSize: 11.0)
        upperValueLbl.backgroundColor = UIColor.white
        upperValueLbl.layer.cornerRadius = 14
        upperValueLbl.layer.borderWidth = 1.0
        upperValueLbl.layer.borderColor = UIColor.lightGray.cgColor
        upperValueLbl.clipsToBounds = true

        view.addSubview(upperValueLbl)
    }

    @objc func actionOnCurrencyBtns(sender:UIButton) {
        
        switch sender.tag {
        case 1:
            sliderMinValue = 8.0
            sliderMaxValue = 7800.0
            sliderLowerValue = 8.0
            sliderUpperValue = 7800.0
        case 2:
            sliderMinValue = 309200.0
            sliderMaxValue = 309200000.0
            sliderLowerValue = 309200.0
            sliderUpperValue = 309200000.0
        case 3:
            sliderMinValue = 10.0
            sliderMaxValue = 10000.0
            sliderLowerValue = 10.0
            sliderUpperValue = 10000.0
        case 4:
            sliderMinValue = 700.0
            sliderMaxValue = 700000.0
            sliderLowerValue = 700.0
            sliderUpperValue = 700000.0
        default:
            break
        }
        
        initializeSlider()
        
        lowerValueLbl.text = "\(Int(sliderLowerValue))"
        upperValueLbl.text = "\(Int(sliderUpperValue))"
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
        
        lowerValueLbl.frame.size.width = ((lowerValueLbl.intrinsicContentSize.width + 10) > 40) ? (lowerValueLbl.intrinsicContentSize.width + 20) : 40
        upperValueLbl.frame.size.width = ((upperValueLbl.intrinsicContentSize.width + 10) > 40) ?
            (upperValueLbl.intrinsicContentSize.width + 20) : 40
        
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
            
            lowerValueLbl.center.y = minThumbPosition.y
            upperValueLbl.center.y = maxThumbPosition.y
            
            if frameLowerLbl.minX >= slider.frame.minX {
                lowerValueLbl.frame.origin.x = frameLowerLbl.origin.x
            }else {
                lowerValueLbl.frame.origin.x = slider.frame.minX
            }
            
            if frameUpperLbl.maxX <= slider.frame.maxX {
                upperValueLbl.frame.origin.x = frameUpperLbl.origin.x
            }else {
                upperValueLbl.frame.origin.x = slider.frame.maxX - frameUpperLbl.size.width
            }
            
//            lowerValueLbl.center.x = minThumbPosition.x
//            upperValueLbl.center.x = maxThumbPosition.x
//            lowerValueLbl.center.y = minThumbPosition.y
//            upperValueLbl.center.y = maxThumbPosition.y
        }
 
        previousMinPosition = lowerValueLbl.center.x
        previousMaxPosition = upperValueLbl.center.x
    }
}

