//
//  DayViewDiaryViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 31/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import Instructions

class DayViewDiaryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var checkTodayDiary: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var grainLabel: UILabel!
    @IBOutlet weak var ProteinLabel: UILabel!
    @IBOutlet weak var FruitLabel: UILabel!
    @IBOutlet weak var VegetableLabel: UILabel!
    @IBOutlet weak var DairyLabel: UILabel!
    @IBOutlet weak var emotionFace: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var colourIndicator: UIView!
    private var userDefault = UserDefaultsHandler()
    private var nutriCalculation: HealthPercentageCalculator?
    private let showDayDetail = ""
    private var lookingDate = ""
    
    private var Standard = [0.0,0.0,0.0,0.0,0.0]
    private var todayCount = [0.0,0.0,0.0,0.0,0.0]
    private var eachDayPercentage: [Double] = []
    
    private var dateSaved: [String] = []
    
    // Nutrition Info Variables
    var dairyList: [Double] = []
    var vegetableList: [Double] = []
    var proteinList: [Double] = []
    var fruitList: [Double] = []
    var grainList: [Double] = []
    
    private var todayHasRecord = 0
    
    private var loadListcount = 0
    
    var dataEditedFromDiary = false
    var dataDeletedFromDiary = false
    
    
    let format = DateFormatter()
    private var notes: [String] = [] // Storing notes
    private var dates: [Date] = [] // Storing dates
    private var id: [String] = []
    
    // For tutorial walkthrough
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        recentTableView.delegate = self
        recentTableView.dataSource = self
        updateData()
        
        // Tutorial
        if id.count > 0 && userDefault.getDayDiaryTutorialStatus() == false
        {
            self.coachMarksController.dataSource = self
            self.coachMarksController.start(on: self)
            self.coachMarksController.overlay.allowTap = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        var dataHandler = CoreDataHandler()
        let newCount = dataHandler.getId().count
        
        if loadListcount != newCount
        {
            dates = dataHandler.getTimestamp()
            if dates.count > 0
            {
                if format.string(from: dates[0]) != format.string(from: Date())
                {
                    todayHasRecord = 0
                }
            }else
            {
                todayHasRecord = 0
            }
            todayDiary()
            loadListcount = newCount
        }else
        {
            print("Nothing changed")
        }
        
        if dataDeletedFromDiary || dataEditedFromDiary
        {
            updateData()
            recentTableView.reloadData()
        }
    }
    
    func todayDiary()
    {
        if todayHasRecord == 1
        {
            let todayPercentage = eachDayPercentage[0]
            todayCount = nutriCalculation!.getTodayEachElementData()
            balanceLabel.text = "\(todayPercentage)% " + "Balance".localized()
            grainLabel.text = "\(todayCount[0]) / \(Standard[0]) " + "Grain".localized()
            VegetableLabel.text = "\(todayCount[1]) / \(Standard[1]) " + "Vegetable".localized()
            FruitLabel.text = "\(todayCount[2]) / \(Standard[3]) " + "Fruit".localized()
            DairyLabel.text = "\(todayCount[3]) / \(Standard[4]) " + "Dairy".localized()
            ProteinLabel.text = "\(todayCount[4]) / \(Standard[2]) " + "Protein".localized()
            
            if todayPercentage < 20.0
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Red")
                backgroundImage.image = #imageLiteral(resourceName: "Image_Diary_todayArea_Red")
            }else if todayPercentage >= 20.0 && todayPercentage < 60.0
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Yellow")
                backgroundImage.image = #imageLiteral(resourceName: "Image_Diary_todayArea_Yellow")
            }else if todayPercentage >= 60.0 && todayPercentage < 80.0
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Green")
                backgroundImage.image = #imageLiteral(resourceName: "Image_Diary_todayArea_Green")
            }else
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Orange")
                backgroundImage.image = #imageLiteral(resourceName: "Image_Diary_todayArea_Orange")
            }
            
        }else
        {
            balanceLabel.text = "No Entry Yet!".localized()
            grainLabel.text = "0 / \(Standard[0]) " + "Grain".localized()
            VegetableLabel.text = "0 / \(Standard[1]) " + "Vegetable".localized()
            FruitLabel.text = "0 / \(Standard[3]) " + "Fruit".localized()
            DairyLabel.text = "0 / \(Standard[4]) " + "Dairy".localized()
            ProteinLabel.text = "0 / \(Standard[2]) " + "Protein".localized()
            emotionFace.image = #imageLiteral(resourceName: "Face_Sleep")
        }
    }
    @IBAction func todayTapped(_ sender: Any)
    {
        if todayHasRecord == 1
        {
            format.dateFormat = "yyyy-MM-dd"
            lookingDate = format.string(from: Date())
            performSegue(withIdentifier: "diarySegue", sender: nil)
        }else
        {
            SCLAlertMessage(title: "Oops".localized(), message: "You don't have any records today".localized()).showMessage()
        }
    }
    
    func updateData()
    {
        dateSaved.removeAll()
        fruitList.removeAll()
        dairyList.removeAll()
        vegetableList.removeAll()
        proteinList.removeAll()
        grainList.removeAll()
        eachDayPercentage.removeAll()
        
        dates.removeAll()
        notes.removeAll()
        id.removeAll()
        
        var dataHandler = CoreDataHandler()
        dates = dataHandler.getTimestamp()
        notes = dataHandler.getNote()
        id = dataHandler.getId()
        
        let nutritionDic = dataHandler.get5nList()
        nutriCalculation = HealthPercentageCalculator(nutritionDic: nutritionDic, timestamp: dataHandler.getTimestamp())
        let dayNutritionList = nutriCalculation?.getEachDayCount()
        dairyList = dayNutritionList!["Dairy"]!
        vegetableList = dayNutritionList!["Vegetable"]!
        proteinList = dayNutritionList!["Protein"]!
        fruitList = dayNutritionList!["Fruit"]!
        grainList = dayNutritionList!["Grain"]!
        eachDayPercentage = nutriCalculation!.getDayBalancePercentage()
        dateSaved = (nutriCalculation?.getDateOfRecord())!
        
        Standard = userDefault.getPlanStandard() as! [Double]

        if id.count > 0
        {
            format.dateFormat = "yyyy-MM-dd"
            if format.string(from: dates[0]) == format.string(from: Date())
            {
                todayHasRecord = 1
            }
        }
        // Main Function
        todayDiary()
        loadListcount = id.count
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Number of row")
        print(dateSaved.count - todayHasRecord)
        return dateSaved.count - todayHasRecord
    }
    
    @IBAction func checkAllDetailTapped(_ sender: Any)
    {
        lookingDate = "All"
        performSegue(withIdentifier: "diarySegue", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DayViewDairyTableViewCell
        
        print("table")
        print(dateSaved)
        print(todayHasRecord)
        if dateSaved.count > todayHasRecord
        {
            if (eachDayPercentage[indexPath.row + todayHasRecord] < 20)
            {
                cell?.metalPrize.alpha = 0
                cell?.metalPrize_2.alpha = 0
                cell?.metalPrize3.alpha = 0
                cell?.colourIndicator.backgroundColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0)
            }else if (eachDayPercentage[indexPath.row + todayHasRecord] < 60)
            {
                cell?.metalPrize3.alpha = 0
                cell?.metalPrize.alpha = 0
                cell?.colourIndicator.backgroundColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0)
            }else if (eachDayPercentage[indexPath.row + todayHasRecord] < 80)
            {
                cell?.metalPrize.alpha = 0
                cell?.colourIndicator.backgroundColor = UIColor(red:0.59, green:0.79, blue:0.30, alpha:1.0)
            }else
            {
                cell?.colourIndicator.backgroundColor = UIColor(red:0.94, green:0.60, blue:0.18, alpha:1.0)
            }
            
            cell?.dateAndTime.text = "\(dateSaved[indexPath.row + todayHasRecord])"
            cell?.balance.text = "\(eachDayPercentage[indexPath.row + todayHasRecord])% " + "Balance".localized()
            cell?.grainInfo.text = "\(grainList[indexPath.row + todayHasRecord]) / \(Standard[0])"
            cell?.vegetableInfo.text = "\(vegetableList[indexPath.row + todayHasRecord]) / \(Standard[1])"
            cell?.proteinInfo.text = "\(proteinList[indexPath.row + todayHasRecord]) / \(Standard[2])"
            cell?.fruitInfo.text = "\(fruitList[indexPath.row + todayHasRecord]) / \(Standard[3])"
            cell?.dairyInfo.text = "\(dairyList[indexPath.row + todayHasRecord]) / \(Standard[4])"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        lookingDate = dateSaved[indexPath.row + todayHasRecord]
        performSegue(withIdentifier: "diarySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "diarySegue"
        {
            if let navVC = segue.destination as? UINavigationController
            {
                let tableVC = navVC.viewControllers.first as! DiaryTableViewController
                tableVC.showRecord = lookingDate
            }
            dataEditedFromDiary = true
            dataDeletedFromDiary = true
        }
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension DayViewDiaryViewController: CoachMarksControllerDataSource
{
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?)
    {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index)
        {
        case 0:
            coachViews.bodyView.hintLabel.text = "Check your daily informations right here! Tap on it to check daily activities".localized()
            coachViews.bodyView.nextLabel.text = "Next".localized()
            UserDefaultsHandler().setDayDiaryTutorialStatus(status: true)
        default: break
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch(index)
        {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: backgroundImage)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
        
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int
    {
        return 1
    }
}

