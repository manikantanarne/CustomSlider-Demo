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
    var sliderLowerValue:CGFloat = 200.0
    var sliderUpperValue:CGFloat = 800.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        slider.backgroundColor = UIColor.clear
        slider.minimumValue = 10.0
        slider.maximumValue = 10000.0
        slider.lowerValue = sliderLowerValue
        slider.upperValue = sliderUpperValue
        slider.thumbStrokeWidth = 1.5
        slider.thumbStrokeColor = UIColor.black
        slider.thumbColor = UIColor.red
        slider.rangeLineHeight = 5.0
        slider.rangeLineColor = UIColor.lightGray
        slider.rangeLineHighlightColor = UIColor.blue
        slider.delegate = self
        
        view.addSubview(slider)
        
        let stack = UIStackView(frame: CGRect(x: 20, y: view.bounds.height/2 - 100, width: view.bounds.width - 40, height: 25))
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 50
        
        view.addSubview(stack)
        
        lowerValueLbl.text = "\(Int(sliderLowerValue))"
        lowerValueLbl.textColor = UIColor.black
        lowerValueLbl.textAlignment = .center
        lowerValueLbl.layer.borderColor = UIColor.red.cgColor
        lowerValueLbl.layer.borderWidth = 1.0
        lowerValueLbl.clipsToBounds = true

        stack.addArrangedSubview(lowerValueLbl)

        upperValueLbl.text = "\(Int(sliderUpperValue))"
        upperValueLbl.textColor = UIColor.black
        upperValueLbl.textAlignment = .center
        upperValueLbl.layer.borderColor = UIColor.red.cgColor
        upperValueLbl.layer.borderWidth = 1.0
        upperValueLbl.clipsToBounds = true

        stack.addArrangedSubview(upperValueLbl)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20
        let width = view.bounds.width - 2 * margin
        let height: CGFloat = 30
        
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
}

