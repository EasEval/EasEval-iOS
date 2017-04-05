//
//  AmountViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Charts

//This is the viewController class that controls the amounts graph for the selected exercise. This graph shows how many students who used a given resource the most. The functions are self-explanatory
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
        
        loadDataIntoChart()
    }
    
    func loadDataIntoChart() {
        
        var dataPointValues = [Double]()
        var dataPointLabels = [String]()
        let rawKeys = ["googleAmount","solutionsAmount","curriculumAmount","lectureAmount", "otherAmount"]
        let labels = ["Google", "Solutions","Curriculum","Lectures","Other"]
        
        for key in (current_exercise?.getMostUsedResources().keys)! {
            
            dataPointValues.append(Double(current_exercise!.getMostUsedResourceFromKey(key: key)))
            let labelIndex = rawKeys.index(of: key)
            dataPointLabels.append(labels[labelIndex!])
            //dataPointLabels.append(key)
        }
        setChart(dataPoints: dataPointLabels, values: dataPointValues)
        viewDidLoadProperly = true
    }    
    func setChart(dataPoints:[String], values:[Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "NUMBER OF STUDENTS WHO USED A GIVEN RESOURCE THE MOST")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        barChartView.xAxis.granularity = 1
        chartSetUpCompleted = true
        barChartView.xAxis.labelPosition = .bottom
    }
}
