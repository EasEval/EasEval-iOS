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
    
    var lineChartData_resources = LineChartData()
    var activityIndicator = UIActivityIndicatorView()
    
    var exercisesNameList = [String]()
    
    func runActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        lineChartView.isHidden = true
    }
    
    func stopActivityIndicator() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        self.lineChartView.isHidden = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = subjectList[selectedSubject].getId()
        current_subject = subjectList[selectedSubject]
        
        //let subjectObject = PFObject(className: "Subjects")
        //query.includeKey("SUBJECT")
        //query.whereKey("SUBJECT", equalTo: subjectObject ?? 0)
        
        let query = PFQuery(className: "Exercises")
        query.whereKey("SUBJECTID", equalTo: current_subject?.getId() ?? "")
        query.addAscendingOrder("NAME")
        
        runActivityIndicator()
        
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
                        var comment = ""
                        if object["comment"] != nil {
                            
                            comment = object["comment"] as! String
                        }
                        
                        let googleAmount = object["googleAmount"] as! Double
                        let solutionsAmount = object["solutionsAmount"] as! Double
                        let curriculumAmount = object["curriculumAmount"] as! Double
                        let lectureAmount = object["lectureAmount"] as! Double
                        var otherAmount = 0.0
                        if object["otherAmount"] != nil {
                            
                            otherAmount = object["otherAmount"] as! Double
                        }
                    
                        let maxValList = [googleAmount, solutionsAmount, curriculumAmount, lectureAmount, otherAmount]
                        let maxValNames = ["googleAmount","solutionsAmount","curriculumAmount","lectureAmount","otherAmount"]
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
                        exercises_list[indexToAddValue].addAmountForKey(key: "otherAmount", amount: otherAmount)
                        exercises_list[indexToAddValue].addAmountForKey(key: "rating", amount: rating)
                        exercises_list[indexToAddValue].addAmountForKey(key: "time", amount: time)
                        exercises_list[indexToAddValue].addMostUsedResourceForKey(key: keyMax)
                        self.updateChartWithAmount(amount: "rating", description: "Student ratings of the exercises from 1 - 100, where 100 is best")
                        
                        let newAnswer = Answer(gAm: googleAmount, sAm: solutionsAmount, cAm: curriculumAmount, lAm: lectureAmount, oAm: otherAmount, rating: rating, time: time, comment: comment)
                        
                        exercises_list[indexToAddValue].addAnswer(answer: newAnswer)
                    }
                }
            } else {
                
                self.stopActivityIndicator()
            }
            self.stopActivityIndicator()
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
        self.setChart(dataPoints: exercisesNameList, values: exercises_values, isResources: false,colorIndex: 5)
        lineChartView.chartDescription?.text = description
    }
    
    func updateChartWithResources() {
        
        lineChartData_resources.clearValues()
        
        var google_amounts = [Double]()
        var solutions_amounts = [Double]()
        var curriculum_amounts = [Double]()
        var lecture_amounts = [Double]()
        var other_amounts = [Double]()
        var labels = [String]()
        
        
        for name in exercisesNameList {
            
            let indexExercise = exercisesNameList.index(of: name)!
            let googleAmount = exercises_list[indexExercise].getAmountFromKey(key: "googleAmount").0 
            let solutionsAmount = exercises_list[indexExercise].getAmountFromKey(key: "solutionsAmount").0
            let curriculumAmount = exercises_list[indexExercise].getAmountFromKey(key: "curriculumAmount").0
            let lectureAmount = exercises_list[indexExercise].getAmountFromKey(key: "lectureAmount").0
            let otherAmount = exercises_list[indexExercise].getAmountFromKey(key: "otherAmount").0
            
            let total = googleAmount + solutionsAmount + curriculumAmount + lectureAmount + otherAmount
            
            let google_val = Utilities.getRoundedDouble(double: googleAmount/total) * 100
            let solution_val = Utilities.getRoundedDouble(double: solutionsAmount/total) * 100
            let curriculum_val = Utilities.getRoundedDouble(double: curriculumAmount/total) * 100
            let lecture_val = Utilities.getRoundedDouble(double: lectureAmount/total) * 100
            let other_val = Utilities.getRoundedDouble(double: otherAmount/total) * 100
            
            google_amounts.append(google_val)
            solutions_amounts.append(solution_val)
            curriculum_amounts.append(curriculum_val)
            lecture_amounts.append(lecture_val)
            other_amounts.append(other_val)
            labels.append(name)
            
        }
        
        self.setChart(dataPoints: labels, values: google_amounts, isResources: true,colorIndex: 0)
        self.setChart(dataPoints: labels, values: solutions_amounts, isResources: true,colorIndex: 1)
        self.setChart(dataPoints: labels, values: curriculum_amounts, isResources: true,colorIndex: 2)
        self.setChart(dataPoints: labels, values: lecture_amounts, isResources: true,colorIndex: 3)
        self.setChart(dataPoints: labels, values: other_amounts, isResources: true, colorIndex: 4)
        
        lineChartView.chartDescription?.text = "RESOURCES USED TO SOLVE THE DIFFERENT EXERCISES GIVEN IN PERCENTAGE"
    }
    
    let resourceColors = [UIColor.blue, UIColor.black, UIColor.yellow, UIColor.green, UIColor.red]
    let resourceLabels = ["% Google","% Solutions","% Curriculum","% Lectures","% Other","Exercises"]
    
    func setChart(dataPoints:[String], values:[Double], isResources:Bool, colorIndex:Int) {
        
        var dataEntries: [BarChartDataEntry] = []
        var colors_chart = [UIColor]()
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntry.accessibilityLabel = "Test"
            dataEntries.append(dataEntry)
            if isResources {
                
                colors_chart.append(resourceColors[colorIndex%resourceColors.count])
            } else {
             
                colors_chart.append(Utilities.getRandomColor(divideNum: 255))
            }
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: resourceLabels[colorIndex])
        
        chartDataSet.colors = colors_chart
        chartDataSet.drawValuesEnabled = true
    
        //chartDataSet.colors = ChartColorTemplates.colorful()
        var chartData = LineChartData()
        chartData.setDrawValues(true)
        if isResources {
            
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.drawCircleHoleEnabled = false
            chartData = lineChartData_resources
            chartDataSet.lineWidth = 2.0
        } else {
            
            chartDataSet.drawFilledEnabled = true
        }
        
        chartData.addDataSet(chartDataSet)
        lineChartView.data = chartData
        
        lineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0.4)
    }

    @IBAction func changeSegmentValue(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            
            self.updateChartWithAmount(amount: "rating", description: "Student ratings of the exercises from 1 - 100, where 100 is best")
            
        case 1:
            
            self.updateChartWithAmount(amount: "time",description: "Time students spent on the exercises given in percentage")
        
        case 2:
            
            self.updateChartWithResources()
            
        default:
            break
        }

    }

    @IBAction func logout(_ sender: Any) {
        
        logoutAlert("Logout", message: "Sure you want to logout?", view: self)
    }
    
    func logout() {
        
        PFUser.logOut()
        self.performSegue(withIdentifier: "segue_logout_from_subject", sender: self)

    }
    
    func logoutAlert(_ title: String, message: String, view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            
            self.logout()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        view.present(alert, animated: true, completion: nil)
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
