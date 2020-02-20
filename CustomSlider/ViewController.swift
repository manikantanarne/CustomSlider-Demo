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
    
    let lowerValueTextField = UITextField()
    let upperValueTextField = UITextField()
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
        
        lowerValueTextField.frame = CGRect(x: 0, y: 0, width: 100, height: 28)
        lowerValueTextField.text = "\(Int(sliderLowerValue))"
        lowerValueTextField.textColor = UIColor.black
        lowerValueTextField.textAlignment = .center
        lowerValueTextField.keyboardType = .numberPad
        lowerValueTextField.font = UIFont.systemFont(ofSize: 11.0)
        lowerValueTextField.backgroundColor = UIColor.white
        lowerValueTextField.layer.cornerRadius = 14
        lowerValueTextField.layer.borderWidth = 1.0
        lowerValueTextField.layer.borderColor = UIColor.lightGray.cgColor
        lowerValueTextField.clipsToBounds = true
        lowerValueTextField.delegate = self

        view.addSubview(lowerValueTextField)

        upperValueTextField.frame = CGRect(x: 0, y: 0, width: 50, height: 28)
        upperValueTextField.text = "\(Int(sliderUpperValue))"
        upperValueTextField.textColor = UIColor.black
        upperValueTextField.textAlignment = .center
        upperValueTextField.keyboardType = .numberPad
        upperValueTextField.font = UIFont.systemFont(ofSize: 11.0)
        upperValueTextField.backgroundColor = UIColor.white
        upperValueTextField.layer.cornerRadius = 14
        upperValueTextField.layer.borderWidth = 1.0
        upperValueTextField.layer.borderColor = UIColor.lightGray.cgColor
        upperValueTextField.clipsToBounds = true
        upperValueTextField.delegate = self

        view.addSubview(upperValueTextField)
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
        
        lowerValueTextField.text = "\(Int(sliderLowerValue))"
        upperValueTextField.text = "\(Int(sliderUpperValue))"
    }

}


extension ViewController:TwoWaySliderProtocol {
    func sliderValueChanges(lowerValue: Double, upperValue: Double) {
        sliderLowerValue = CGFloat(lowerValue)
        sliderUpperValue = CGFloat(upperValue)
        lowerValueTextField.text = "\(Int(lowerValue))"
        upperValueTextField.text = "\(Int(upperValue))"
    }
    
    func positionChangesForThumbs(minThumbPosition: CGPoint, maxThumbPosition: CGPoint, isMinThumbMoving:Bool, isMaxThumbMoving:Bool) {
        
        view.endEditing(true)
        
        lowerValueTextField.frame.size.width = ((lowerValueTextField.intrinsicContentSize.width + 10) > 40) ? (lowerValueTextField.intrinsicContentSize.width + 20) : 40
        upperValueTextField.frame.size.width = ((upperValueTextField.intrinsicContentSize.width + 10) > 40) ?
            (upperValueTextField.intrinsicContentSize.width + 20) : 40
        
        let lowerLabelXPosition = ((minThumbPosition.x - lowerValueTextField.frame.size.width/2) >= slider.frame.minX) ? (minThumbPosition.x - lowerValueTextField.frame.size.width/2) : slider.frame.minX
        let frameLowerLbl = CGRect(x: lowerLabelXPosition, y: lowerValueTextField.frame.origin.y, width: lowerValueTextField.frame.size.width, height: lowerValueTextField.frame.size.height)
        
        let upperLabelXPosition = ((maxThumbPosition.x + upperValueTextField.frame.size.width/2) <= slider.frame.maxX) ? (maxThumbPosition.x - upperValueTextField.frame.size.width/2) : (slider.frame.maxX - upperValueTextField.frame.size.width)
        let frameUpperLbl = CGRect(x: upperLabelXPosition, y: upperValueTextField.frame.origin.y, width: upperValueTextField.frame.size.width, height: upperValueTextField.frame.size.height)
        
        if isMinThumbMoving == true {
            
            if frameLowerLbl.minX > slider.frame.minX {
                
                if frameLowerLbl.intersects(frameUpperLbl) {
                    if (frameLowerLbl.maxX + frameUpperLbl.size.width) < slider.frame.maxX {
                        if (maxThumbPosition.x - minThumbPosition.x) > 20 {
                            upperValueTextField.frame.origin.x = frameLowerLbl.maxX
                            lowerValueTextField.center.x = minThumbPosition.x
                        }else {
                            if let positionMax = previousMaxPosition, let positionMin = previousMinPosition {
                                lowerValueTextField.center.x = positionMin
                                upperValueTextField.center.x = positionMax
                            }
                        }
                    }else {
                        if let positionMin = previousMinPosition, let positionMax = previousMaxPosition {
                            lowerValueTextField.center.x = positionMin
                            upperValueTextField.center.x = positionMax
                        }
                    }
                }else {
                    lowerValueTextField.center.x = minThumbPosition.x
                }
                
            }else {
                if let positionMin = previousMinPosition {
                    lowerValueTextField.center.x = positionMin
                }
            }
        }else if isMaxThumbMoving == true {
            
            if frameUpperLbl.maxX < slider.frame.maxX {
                
                if frameUpperLbl.intersects(frameLowerLbl) {
                    
                    if (frameUpperLbl.minX - lowerValueTextField.frame.size.width) > slider.frame.minX {
                        
                        if (maxThumbPosition.x - minThumbPosition.x) > 20 {
                            lowerValueTextField.frame.origin.x = (frameUpperLbl.minX - lowerValueTextField.frame.size.width)
                            upperValueTextField.center.x = maxThumbPosition.x
                        }else {
                            if let positionMax = previousMaxPosition, let positionMin = previousMinPosition {
                                lowerValueTextField.center.x = positionMin
                                upperValueTextField.center.x = positionMax
                            }
                        }
                        
                        
                    }else {
                        if let positionMax = previousMaxPosition, let positionMin = previousMinPosition {
                            lowerValueTextField.center.x = positionMin
                            upperValueTextField.center.x = positionMax
                        }
                    }
                }else {
                    upperValueTextField.center.x = maxThumbPosition.x
                }
                
            }else {
                if let positionMax = previousMaxPosition {
                    upperValueTextField.center.x = positionMax
                }
            }
        }else {
            
            lowerValueTextField.center.y = minThumbPosition.y
            upperValueTextField.center.y = maxThumbPosition.y
            
            if frameLowerLbl.minX > slider.frame.minX {
                if frameLowerLbl.intersects(frameUpperLbl) {
                    lowerValueTextField.frame.origin.x = frameUpperLbl.minX - frameLowerLbl.size.width
                }else {
                    lowerValueTextField.frame.origin.x = frameLowerLbl.minX
                }
            }else {
                lowerValueTextField.frame.origin.x = slider.frame.minX
            }
            
            if frameUpperLbl.maxX <= slider.frame.maxX {
                if frameUpperLbl.intersects(frameLowerLbl) {
                    upperValueTextField.frame.origin.x = lowerValueTextField.frame.maxX
                }else {
                    upperValueTextField.frame.origin.x = frameUpperLbl.minX
                }
            }else {
                upperValueTextField.frame.origin.x = slider.frame.maxX - frameUpperLbl.size.width
            }
        }
 
        previousMinPosition = lowerValueTextField.center.x
        previousMaxPosition = upperValueTextField.center.x
    }
}


extension ViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == lowerValueTextField {
            if let text = textField.text, text.count > 0, let enteredValue =  Int(text) {
                if CGFloat(enteredValue) >= sliderMinValue {
                    if CGFloat(enteredValue) <= sliderUpperValue {
                        sliderLowerValue = CGFloat(enteredValue)
                        initializeSlider()
                    }else {
                        lowerValueTextField.text = "\(Int(sliderLowerValue))"
                        showAlertWith(Message: "Value should be less than or equal to selected upper value")
                    }
                }else {
                    lowerValueTextField.text = "\(Int(sliderLowerValue))"
                    showAlertWith(Message: "Value should be greater than or equal to minimum value")
                }
            }else {
                lowerValueTextField.text = "\(Int(sliderLowerValue))"
                showAlertWith(Message: "Value entered is not valid")
            }
        }else if textField == upperValueTextField {
            if let text = textField.text, text.count > 0, let enteredValue = Int(text) {
                if CGFloat(enteredValue) <= sliderMaxValue {
                    if CGFloat(enteredValue) >= sliderLowerValue {
                        sliderUpperValue = CGFloat(enteredValue)
                        initializeSlider()
                    }else {
                        upperValueTextField.text = "\(Int(sliderUpperValue))"
                        showAlertWith(Message: "Value should be greater than or equal to selected lower value")
                    }
                }else {
                    upperValueTextField.text = "\(Int(sliderUpperValue))"
                    showAlertWith(Message: "Value should be less than or equal to maximum value")
                }
            }else {
                lowerValueTextField.text = "\(Int(sliderUpperValue))"
                showAlertWith(Message: "Value entered is not valid")
            }
        }
        
        return true
    }
    
    
    //MARK: Show Alert
    func showAlertWith(Message message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
