/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet var testButton: UIButton!
    
    var num = 0
    
    @IBAction func testAction(_ sender: Any) {
        
        uploadSomething(i: num)
        num += 1
    }
    
    func uploadSomething(i:Int) {
        
        let testObject = PFObject(className: "TestObject")
        testObject["TestNum"] = i
        testObject.saveInBackground { (success, error) in
            
            if success {
                
                print("Object has been saved.")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //testButton.frame.width = testButton.frame.size.
        self.testButton.layer.cornerRadius = self.testButton.frame.size.width/2;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
