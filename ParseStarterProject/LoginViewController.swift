/**
*
*
*/

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var buttonLogin: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func actionLogin(_ sender: Any) {
        
        let name = textFieldName.text!
        let password = textFieldPassword.text!
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.view.alpha = 0.5
        
        logInUser(name: name, password: password)
    }
    
    func logInUser(name:String, password:String) {
        
        PFUser.logInWithUsername(inBackground: name, password: password) { (user, error) in
            
            if user != nil {
                
                UserDefaults.standard.set(name, forKey: "NAME")
                UserDefaults.standard.set(password, forKey: "PASSWORD")
                self.performSegue(withIdentifier: "segue_to_subjects", sender: self)
                
            } else {
                
                Utilities.displayAlert("Obs",message: "Feil brukernavn eller passord", view: self)
            }
            self.view.alpha = 1
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = UserDefaults.standard.value(forKey: "NAME") as? String
        let password = UserDefaults.standard.value(forKey: "PASSWORD") as? String
        
        if name != nil && password != nil {
            
            textFieldName.text = name
            textFieldPassword.text = password
        }
        
        self.buttonLogin.layer.cornerRadius = self.buttonLogin.frame.size.width/2
        self.buttonLogin.layer.borderWidth = 0.5
        self.buttonLogin.layer.borderColor = UIColor.darkGray.cgColor
        activityIndicator.stopAnimating()
        
        if PFUser.current() != nil {
            
            self.performSegue(withIdentifier: "segue_to_subjects", sender: self)
            //logInUser(name: name, password: password)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
