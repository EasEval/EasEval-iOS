//
//  Utilities.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func displayAlert(_ title: String, message: String, view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
            
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
    
    static func getRandomColor(divideNum:Double) -> UIColor {
        
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
            
        let color = UIColor(red: CGFloat(red/divideNum), green: CGFloat(green/divideNum), blue: CGFloat(blue/divideNum), alpha: 1)
        return color
        
    }
    
    static func getRoundedDouble(double:Double) -> Double {
        
        return Double(round(10*double)/10)
    }
}
