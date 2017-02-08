/**
*
*
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
    
    func getSomething() {
        
        let testQuery = PFQuery(className: "TestObject")
        testQuery.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                if let objects = objects {
                    
                    for obj in objects {
                        
                        print(obj["TestNum"] as! Int)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testButton.layer.cornerRadius = self.testButton.frame.size.width/2;
        
        getSomething()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
