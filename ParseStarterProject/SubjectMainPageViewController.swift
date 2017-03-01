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
        
        
        var exercises_names = [String]()
        var exercises_values = [Double]()
        var chartValues = [String(): (Double(), Double())]
        
        let query = PFQuery(className: "Exercises")
        //let subjectObject = PFObject(className: "Subjects")
        //query.includeKey("SUBJECT")
        //query.whereKey("SUBJECT", equalTo: subjectObject ?? 0)
        query.whereKey("SUBJECTID", equalTo: current_subject?.getId() ?? "")
        query.addAscendingOrder("NAME")
        
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil && objects!.count > 0 {
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        let key = object["NAME"] as! String
                        let rating = object["rating"] as! Double
                        
                        if !exercises_names.contains(key) {
                         
                            exercises_names.append(key)
                        }
                        
                        if !chartValues.keys.contains(key) {
                            
                            chartValues[key] = (rating, 1)
                        } else {
                            
                            chartValues[key]!.0 += rating
                            chartValues[key]!.1 += 1
                        }
                    }
                    
                    for name in exercises_names {
                        
                        let value = (chartValues[name]!.0)/(chartValues[name]!.1)
                        exercises_values.append(value)
                    }
                    self.setChart(dataPoints: exercises_names, values: exercises_values)
                    
                }
            }
        }
        
        //setChart(dataPoints: months, values: dollars1)
    }
    
    func setChart(dataPoints:[String], values:[Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        var colors_chart = [UIColor]()
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntry.accessibilityLabel = "Test"
            dataEntries.append(dataEntry)
            colors_chart.append(getRandomColor())
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Exercises")
        
        chartDataSet.colors = colors_chart
        //chartDataSet.colors = ChartColorTemplates.colorful()
        
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        
        lineChartView.data = chartData
        
        lineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        lineChartView.chartDescription?.text = "Student ratings of the exercises"
    
        lineChartView.xAxis.granularity = 1
        lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0.4)
    }

    func getRandomColor() -> UIColor {
        
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        return color
        
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
