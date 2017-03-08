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
var exercises_list = [Exercise]()

class SubjectMainPageViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var exercisesNameList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = subjectList[selectedSubject].getId()
        current_subject = subjectList[selectedSubject]
        
        let query = PFQuery(className: "Exercises")
        //let subjectObject = PFObject(className: "Subjects")
        //query.includeKey("SUBJECT")
        //query.whereKey("SUBJECT", equalTo: subjectObject ?? 0)
        query.whereKey("SUBJECTID", equalTo: current_subject?.getId() ?? "")
        query.addAscendingOrder("NAME")
        
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil && objects!.count > 0 {
                
                if let objects = objects {
                    
                    exercises_list.removeAll()
                    self.exercisesNameList.removeAll()
                    for object in objects {
                        
                        let name = object["NAME"] as! String
                        let id = object.objectId
                        let subID = object["SUBJECTID"] as! String
                        
                        let time = object["time"] as! Double
                        let rating = object["rating"] as! Double
                        let googleAmount = object["googleAmount"] as! Double
                        let solutionsAmount = object["solutionsAmount"] as! Double
                        let curriculumAmount = object["curriculumAmount"] as! Double
                        let lectureAmount = object["lectureAmount"] as! Double
                        
                        let maxValList = [googleAmount, solutionsAmount, curriculumAmount, lectureAmount]
                        let maxValNames = ["googleAmount","solutionsAmount","curriculumAmount","lectureAmount"]
                        
                        let maxIndex = maxValList.index(of: maxValList.max()!)
                        let keyMax = maxValNames[maxIndex!]
                        
                        
                        if !self.exercisesNameList.contains(name) {
                            
                            let newExercise = Exercise(id: id!, name: name, subId: subID)
                            exercises_list.append(newExercise)
                            
                            self.exercisesNameList.append(name)
                        }
                        let indexToAddValue = self.exercisesNameList.index(of: name)!
                        exercises_list[indexToAddValue].addAmountForKey(key: "googleAmount", amount: googleAmount)
                        exercises_list[indexToAddValue].addAmountForKey(key: "solutionsAmount", amount: solutionsAmount)
                        exercises_list[indexToAddValue].addAmountForKey(key: "curriculumAmount", amount: curriculumAmount)
                        exercises_list[indexToAddValue].addAmountForKey(key: "lectureAmount", amount: lectureAmount)
                        exercises_list[indexToAddValue].addAmountForKey(key: "rating", amount: rating)
                        exercises_list[indexToAddValue].addAmountForKey(key: "time", amount: time)
                        
                        exercises_list[indexToAddValue].addMostUsedResourceForKey(key: keyMax)
                        
                        self.updateChartWithAmount(amount: "rating", description: "Student ratings of the exercises")
                        
                    }
                    
                    
                }
            }
        }
        
        //setChart(dataPoints: months, values: dollars1)
    }
    
    func updateChartWithAmount(amount:String, description:String) {
        
        var exercises_values = [Double]()
        for checkName in exercisesNameList {
            
            let indexToAddValue2 = exercisesNameList.index(of: checkName)!
            let val = exercises_list[indexToAddValue2].getAmountFromKey(key: amount).0/exercises_list[indexToAddValue2].getAmountFromKey(key: amount).1
            exercises_values.append(val)
        }
        self.setChart(dataPoints: exercisesNameList, values: exercises_values)
        lineChartView.chartDescription?.text = description
    }
    
    func setChart(dataPoints:[String], values:[Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        var colors_chart = [UIColor]()
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntry.accessibilityLabel = "Test"
            dataEntries.append(dataEntry)
            colors_chart.append(Utilities.getRandomColor(divideNum: 255))
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Exercises")
        
        chartDataSet.colors = colors_chart
        //chartDataSet.colors = ChartColorTemplates.colorful()
        
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        
        lineChartView.data = chartData
        
        lineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        lineChartView.xAxis.granularity = 1
        lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0.4)
    }

    @IBAction func changeSegmentValue(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            
            self.updateChartWithAmount(amount: "rating", description: "Student ratings of the exercises")
            
        case 1:
            
            self.updateChartWithAmount(amount: "time",description: "Time students spent on the exercises")
            
        default:
            break
        }

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
