//
//  ReportViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import ScrollableGraphView
import FirebaseAnalytics

class ReportViewController: UIViewController, ScrollableGraphViewDataSource
{
    
    @IBOutlet weak var graphField: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var typeHumanLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    
    // Add graph view and add constraints to it
    var graphView: ScrollableGraphView!
    var graphConstraints = [NSLayoutConstraint]()
    
    // Data for graphs with multiple plots
    var blueLinePlotData: [Double]?
    // An initial array when no data is found i.e. First time using
    var blank = [0.0]
    // An array to show all related dates
    var dates: [String]?
    
    // Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //Get initial data from core Data
        var coreManager = CoreDataHandler()
        //Calculate data
        var healthData = HealthPercentageCalculator(nutritionDic: coreManager.get5nList(), timestamp: coreManager.getTimestamp())
        dates = healthData.getTrimmedDate()
        blueLinePlotData = healthData.getDayBalancePercentage()
        personType(allElementPercentage: healthData.getElementPercentage())
        // Create graph
        graphView = createMultiPlotGraph(self.graphField.frame)
        graphView.backgroundFillColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        self.graphField.addSubview(graphView)
        percentageLabel.text = "\((round(healthData.getAverageHealth()*100)/100))%"
        setupConstraints()
        
    }
    
    // drawing the values to the graph
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if blueLinePlotData!.count > 0
        {
            return blueLinePlotData![pointIndex]
        }
        return blank[pointIndex]
    }
    
    // Adding labels below the graph
    func label(atIndex pointIndex: Int) -> String {
        // Ensure that you have a label to return for the index
        if dates!.count > 0
        {
            return "\(dates![pointIndex].suffix(5))"
        }else{
            return "No Data Available".localized()
        }
    }
    
    /*Show personal most preference food groups*/
    func personType(allElementPercentage: [String:Double])
    {
        let maxValueGroup = allElementPercentage.max(by: {a,b in a.value < b.value})
        typeHumanLabel.text = "You are a type of ".localized() + "\(maxValueGroup?.key ?? "foody") human".localized()
        if maxValueGroup!.value != 0
        {
            if let personType = maxValueGroup?.key
            {
                switch personType {
                case "Vegetable":
                    typeImage.image = #imageLiteral(resourceName: "Icon_Vegetable")
                case "Protein":
                    typeImage.image = #imageLiteral(resourceName: "Icon_Protein")
                case "Grain":
                    typeImage.image = #imageLiteral(resourceName: "Icon_Grain")
                case "Fruit":
                    typeImage.image = #imageLiteral(resourceName: "Icon_Fruit")
                case "Dairy":
                    typeImage.image = #imageLiteral(resourceName: "Icon_Dairy")
                default:
                    print("No data")
                }
            }
        }else
        {
            typeHumanLabel.text = "You don't have enough data yet :-(".localized()
        }
    }
    
    // return the numbers of plots to draw
    func numberOfPoints() -> Int {
        if blueLinePlotData!.count > 0
        {
            return blueLinePlotData!.count
        }
        return blank.count
    }
    
    // Create the graph
    fileprivate func createMultiPlotGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.backgroundFillColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        
        blueLinePlot.lineWidth = 8
        blueLinePlot.lineColor = UIColor.colorFromHex(hexString: "#FFB900")
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        blueLinePlot.shouldFill = true
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = UIColor.colorFromHex(hexString: "#F8D77F")
        
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        
        // Setup the graphField
        graphView.backgroundFillColor = UIColor.white
        
        graphView.dataPointSpacing = 80
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = false
        
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graphField.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        return graphView
    }
    
    // Constraints and Helper Functions
    // ################################
    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.graphField, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.graphField, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.graphField, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.graphField, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        self.graphField.addConstraints(graphConstraints)
    }
}
