//
//  ReportViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 19/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import ScrollableGraphView

class ReportViewController: UIViewController, ScrollableGraphViewDataSource
{
    @IBOutlet weak var graphField: UIView!
    var graphView: ScrollableGraphView!
    var graphConstraints = [NSLayoutConstraint]()
    
    // Data for graphs with multiple plots
    lazy var blueLinePlotData: [Double] = [67.0,42.0,50.0,12.0,77.0,90.0]
    
    // Init
    // ####
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView = createMultiPlotGraph(self.graphField.frame)
        graphView.backgroundFillColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        self.graphField.addSubview(graphView)
        setupConstraints()
    }
    
    // Implementation for ScrollableGraphViewDataSource protocol
    // #########################################################
    
    // You would usually only have a couple of cases here, one for each
    // plot you want to display on the graphField. However as this is showing
    // off many graphs with different plots, we are using one big switch
    // statement.
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return blueLinePlotData[pointIndex]
    }
    
    func label(atIndex pointIndex: Int) -> String {
        // Ensure that you have a label to return for the index
        return "FEB \(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return blueLinePlotData.count
    }
    
    // Multi plot v2
    // min: 0
    // max: determined from active points
    // The max reference line will be the max of all visible points
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
