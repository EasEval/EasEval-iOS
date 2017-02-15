//
//  SubjectMainPageViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SubjectMainPageViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = subjectList[selectedSubject].getId()
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
