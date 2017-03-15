//
//  TimeChartViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.03.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Charts

class TimeChartViewController: UIViewController {

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
    
    override func viewDidAppear(_ animated: Bool) {
        
        //loadDataIntoView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataIntoView() {
        
        let labels = ["Very much","Much","Average","Less","Little/nothing"]
        var values = [0.0,0.0,0.0,0.0,0.0]
        
        for answer in current_exercise!.getAnswers() {
            
            if answer.getTime() >= 80 {
                
                values[0] += 1
            } else if answer.getTime() >= 60 {
                
                values[1] += 1
            } else if answer.getTime() >= 40 {
                
                values[2] += 1
            } else if answer.getTime() >= 20 {
                
                values[3] += 1
            } else {
                
                values[4] += 1
            }
        }
        
        setChart(dataPoints: labels, values: values)
    }
    
    func setChart(dataPoints:[String], values:[Double]) {
        
        //var yValues : [ChartDataEntry] = [ChartDataEntry]()
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Time spent")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        barChartView.chartDescription?.text = "NUMBER OF STUDENTS WHO SPENT A GIVEN TIME ON THE EXERCISE"
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
