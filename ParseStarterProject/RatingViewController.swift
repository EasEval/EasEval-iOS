//
//  RatingViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Charts

//This is the viewController class that controls the ratings graph for the selected exercise. The functions are self-explanatory
class RatingViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationItem.title = current_exercise?.getName()
        loadDataIntoView()
    }
    
    func loadDataIntoView() {
        
        let labels = ["100 - 80","80 - 60","60 - 40","40 - 20","20 - 0"]
        var values = [0.0,0.0,0.0,0.0,0.0]
        
        for answer in current_exercise!.getAnswers() {
            
            if answer.getRating() >= 80 {
                
                values[0] += 1
            } else if answer.getRating() >= 60 {
                
                values[1] += 1
            } else if answer.getRating() >= 40 {
                
                values[2] += 1
            } else if answer.getRating() >= 20 {
                
                values[3] += 1
            } else {
                
                values[4] += 1
            }
        }
        setChart(dataPoints: labels, values: values)
    }
    
    func setChart(dataPoints:[String], values:[Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Ratings")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        barChartView.chartDescription?.text = "HOW MANY STUDENTS WHO RATED THE EXERCISE WITHIN THE GIVEN LIMITS"
    }
}
