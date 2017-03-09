//
//  AmountViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Charts

class AmountViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var barChartView: BarChartView!
    
    var viewDidLoadProperly = false
    var chartSetUpCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = current_exercise?.getName()
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        var dataPointValues = [Double]()
        var dataPointLabels = [String]()
        let rawKeys = ["googleAmount","solutionsAmount","curriculumAmount","lectureAmount"]
        let labels = ["Google", "Solutions","Curriculum","Lectures"]
        
        for key in (current_exercise?.getMostUsedResources().keys)! {
            
            dataPointValues.append(Double(current_exercise!.getMostUsedResourceFromKey(key: key)))
            
            let labelIndex = rawKeys.index(of: key)
            dataPointLabels.append(labels[labelIndex!])
            //dataPointLabels.append(key)
            
        }
        
        setChart(dataPoints: dataPointLabels, values: dataPointValues)
        viewDidLoadProperly = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints:[String], values:[Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Number of students who used a given resource the most")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.chartDescription?.text = ""
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        barChartView.xAxis.granularity = 1
        chartSetUpCompleted = true
    }

}
