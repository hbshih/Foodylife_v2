//
//  NutritionSettingTableViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 02/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit

class NutritionSettingTableViewController: UITableViewController {
    
    //Outlets
    @IBOutlet weak var maleCell: UITableViewCell!
    @IBOutlet weak var femaleCell: UITableViewCell!
    @IBOutlet weak var customCell: UITableViewCell!
    @IBOutlet weak var grainValue: UITextField!
    @IBOutlet weak var vegetableValue: UITextField!
    @IBOutlet weak var proteinValue: UITextField!
    @IBOutlet weak var fruitValue: UITextField!
    @IBOutlet weak var dairyValue: UITextField!
    @IBOutlet weak var grainSwitch: UIStepper!
    @IBOutlet weak var vegetableSwitch: UIStepper!
    @IBOutlet weak var proteinSwitch: UIStepper!
    @IBOutlet weak var fruitSwitch: UIStepper!
    @IBOutlet weak var dairySwitch: UIStepper!
    
    //Info from https://www.eatforhealth.gov.au/food-essentials/how-much-do-we-need-each-day/recommended-number-serves-adults
    private var standard: [Double] = [0.0,0.0,0.0,0.0,0.0] // Grain,Protein,Vegetable,Fruit,Dairy
    private let maleDefaultSet = numberOfServes().getMaleSet()
    private let femaleDefauthSet = numberOfServes().getFemaleSet()
    private let custom = numberOfServes().getCustom()
    var planType:String = ""
    
    var defaults = UserDefaultsHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        valueEditable(flag: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Get current data and put checkmark on the interface
        if let plan = defaults.getPlanStandard() as? [Double]
        {
            standard = plan
            setTextfields()
            if plan == maleDefaultSet
            {
                maleCell.accessoryType = .checkmark
                planType = "Standard Male"
            }else if plan == femaleDefauthSet
            {
                femaleCell.accessoryType = .checkmark
                planType = "Standard Female"
            }else
            {
                customCell.accessoryType = .checkmark
                valueEditable(flag: true)
                planType = "Custom"
            }
        }
    }
    
    @IBAction func grainStepper(_ sender: UIStepper)
    {
        //Change values for(Custom)
        let value = Double(sender.value)
        switch sender.tag
        {
        case 0:
            grainValue.text = String(value)
        case 1:
            vegetableValue.text = String(value)
        case 2:
            proteinValue.text = String(value)
        case 3:
            fruitValue.text = String(value)
        case 4:
            dairyValue.text = String(value)
        default:
            print("default")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStandard()
    {
        if planType == "Standard Male"
        {
            standard = maleDefaultSet
        }else if planType == "Standard Female"
        {
            standard = femaleDefauthSet
        }else
        {
            //nothing
        }
        setTextfields()
    }
    
    /*Save to userdefaults*/
    override func viewWillDisappear(_ animated: Bool)
    {
        print("Plan Type : \(planType)")
        var Callstandard: [Double] = []
        if planType == "Custom"
        {
            Callstandard = getCustomValues()
        }else
        {
            Callstandard = standard
        }
        defaults.setPlanStandard(value: Callstandard)
    }
    
    
    func getCustomValues() -> [Double]
    {
        return [Double(grainValue.text!)!,Double(vegetableValue.text!)!,Double(proteinValue.text!)!,Double(fruitValue.text!)!,Double(dairyValue.text!)!]
    }
    
    /*User Interface*/
    func setTextfields()
    {
        grainValue.text = String(standard[0])
        vegetableValue.text = String(standard[1])
        proteinValue.text = String(standard[2])
        fruitValue.text = String(standard[3])
        dairyValue.text = String(standard[4])
        
        grainSwitch.value = Double(standard[0])
        vegetableSwitch.value = Double(standard[1])
        proteinSwitch.value = Double(standard[2])
        fruitSwitch.value = Double(standard[3])
        dairySwitch.value = Double(standard[4])
    }
    
    
    func valueEditable(flag: Bool)
    {
        if flag
        {
            grainSwitch.alpha = 1
            vegetableSwitch.alpha = 1
            proteinSwitch.alpha = 1
            fruitSwitch.alpha = 1
            dairySwitch.alpha = 1
            grainValue.alpha = 1
            vegetableValue.alpha = 1
            proteinValue.alpha = 1
            fruitValue.alpha = 1
            dairyValue.alpha = 1
        } else
        {
            grainSwitch.alpha = 0
            vegetableSwitch.alpha = 0
            proteinSwitch.alpha = 0
            fruitSwitch.alpha = 0
            dairySwitch.alpha = 0
            grainValue.alpha = 0.5
            vegetableValue.alpha = 0.5
            proteinValue.alpha = 0.5
            fruitValue.alpha = 0.5
            dairyValue.alpha = 0.5
        }
    }
    
    
    // Setting UI for tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        maleCell.accessoryType = UITableViewCellAccessoryType.none
        femaleCell.accessoryType = UITableViewCellAccessoryType.none
        customCell.accessoryType = UITableViewCellAccessoryType.none
        
        if indexPath.section == 0
        {
            switch indexPath.row
            {
            case 0:
                maleCell.accessoryType = UITableViewCellAccessoryType.checkmark
                femaleCell.accessoryType = UITableViewCellAccessoryType.none
                customCell.accessoryType = UITableViewCellAccessoryType.none
                valueEditable(flag: false)
                planType = "Standard Male"
                
            case 1:
                femaleCell.accessoryType = UITableViewCellAccessoryType.checkmark
                maleCell.accessoryType = UITableViewCellAccessoryType.none
                customCell.accessoryType = UITableViewCellAccessoryType.none
                valueEditable(flag: false)
                planType = "Standard Female"
                
            case 2:
//                customCell.accessoryType = UITableViewCellAccessoryType.checkmark
//                femaleCell.accessoryType = UITableViewCellAccessoryType.none
//                maleCell.accessoryType = UITableViewCellAccessoryType.none
                valueEditable(flag: true)
                planType = "Custom"
            default:
                print("None")
            }
        }
        setStandard()
    }
}
