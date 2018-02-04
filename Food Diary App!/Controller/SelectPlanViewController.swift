//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


class SelectPlanViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var picker: UIPickerView!
    
    private let options = ["Male","Female","Custom"]
    private var selectedOption = ""
    private let maleDefaultSet = [9.0,4.0,7.0,2.0,3.0]
    private let femaleDefauthSet = [6.0,3.0,6.0,2.0,3.0]
    private let custom = [1.0,2.0,3.0,4.0,5.0]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(options[row])
        selectedOption = options[row]
    }
    
    func getSelectedOption() -> [Double]
    {
        if selectedOption == "Male"
        {
            return maleDefaultSet
        }else if selectedOption == "Female"
        {
            return femaleDefauthSet
        }else
        {
            return custom
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       // commentTextField.delegate = self
        picker.delegate = self
        picker.dataSource = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
}
