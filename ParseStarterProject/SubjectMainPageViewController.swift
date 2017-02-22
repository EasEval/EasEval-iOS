//
//  SubjectMainPageViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import Charts

var current_subject:Subject? = nil

class SubjectMainPageViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = subjectList[selectedSubject].getId()
        current_subject = subjectList[selectedSubject]
        
        
        let months = ["O1", "O2", "O3", "O4", "O5","O6"]
        
        let dollars1 = [10.0,20.0,15.0,30.0, 10.0, 17.0]
        
        setChart(dataPoints: months, values: dollars1)
    }
    
    func setChart(dataPoints:[String], values:[Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntry.accessibilityLabel = "Test"
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Exercises")
        let chartData = LineChartData()
        
        chartData.addDataSet(chartDataSet)
        
        lineChartView.data = chartData
        //lineChartView.
        lineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        //Also, you probably we want to add:
        
        lineChartView.xAxis.granularity = 1
    }


    @IBAction func logout(_ sender: Any) {
        
        PFUser.logOut()
        let currentUser = PFUser.current()
        if currentUser == nil {
            
            print("Logout succeeded")
        }
        
        self.performSegue(withIdentifier: "segue_logout_from_subject", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
