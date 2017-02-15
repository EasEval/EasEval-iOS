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
}
