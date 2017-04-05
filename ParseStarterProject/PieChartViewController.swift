//
//  PieChartViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Charts

//This is the viewController class the controls the pieChart/graph. All the functions are self-explanatory. 
class PieChartViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationItem.title = current_exercise?.getName()
        loadDataIntoChart()
    }
    
    func loadDataIntoChart() {
        
        var dataDescriptionLabels = [String]()
        var dataDescriptionPoints = [Double]()
        
        let googleTuple = current_exercise!.getAmountFromKey(key: "googleAmount")
        let solutionTuple = current_exercise!.getAmountFromKey(key: "solutionsAmount")
        let curriculumTuple = current_exercise!.getAmountFromKey(key: "curriculumAmount")
        let lectureTuple = current_exercise!.getAmountFromKey(key: "lectureAmount")
        let otherTuple = current_exercise!.getAmountFromKey(key: "otherAmount")
        
        let total = googleTuple.0/googleTuple.1 + solutionTuple.0/solutionTuple.1 + curriculumTuple.0/curriculumTuple.1 + lectureTuple.0/lectureTuple.1 + otherTuple.0/otherTuple.1
        
        let googlePercentage = Utilities.getRoundedDouble(double: ((googleTuple.0/googleTuple.1)/total) * 100)
        let solutionPercentage = Utilities.getRoundedDouble(double:((solutionTuple.0/solutionTuple.1)/total) * 100)
        let curriculumPercentage = Utilities.getRoundedDouble(double:((curriculumTuple.0/curriculumTuple.1)/total) * 100)
        let lecturePercentage = Utilities.getRoundedDouble(double:((lectureTuple.0/lectureTuple.1)/total) * 100)
        let otherPercentage = Utilities.getRoundedDouble(double: ((otherTuple.0/otherTuple.1)/total) * 100)
        
        dataDescriptionLabels.append("Google")
        dataDescriptionPoints.append(googlePercentage)
        dataDescriptionLabels.append("Solutions")
        dataDescriptionPoints.append(solutionPercentage)
        dataDescriptionLabels.append("Curriculum")
        dataDescriptionPoints.append(curriculumPercentage)
        dataDescriptionLabels.append("Lectures")
        dataDescriptionPoints.append(lecturePercentage)
        dataDescriptionLabels.append("Other")
        dataDescriptionPoints.append(otherPercentage)
        setChart(dataPoints: dataDescriptionLabels, values: dataDescriptionPoints)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.valueTextColor = UIColor.black
        pieChartDataSet.label = ""
        let pieChartData = PieChartData()
        pieChartData.addDataSet(pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        var colors = [UIColor]()
        
        var rgbValues = [(80.0,247.0,218.0),(223.0,56.0,247.0),(208.0, 212.0, 5.0),(181.0, 207.0, 204.0), (150.0, 170.0, 174.0)]
        
        let length = dataPoints.count
        for i in 0..<length {
            
            let color = UIColor(red: CGFloat(rgbValues[i%length].0/255), green: CGFloat(rgbValues[i%length].1/255), blue: CGFloat(rgbValues[i%length].2/255), alpha: 1)
            colors.append(color)
            //colors.append(Utilities.getRandomColor(divideNum: 255))
        }
        
        pieChartDataSet.colors = colors
        //pieChartDataSet.colors = ChartColorTemplates.colorful()
        pieChartView.centerText = "Percentage used %"
        pieChartView.chartDescription?.text = "The percentage of different resources used by the students to solve the exercise"
        pieChartView.legend.enabled = false
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
