//
//  ExercisesTableViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

var current_exercise:Exercise? = nil

//This UITableViewController class controls the exercises list. It provides a table view with all the exercise related to the selected subject, and the ability to click on a subject and be directed to that subject
class ExercisesTableViewController: UITableViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = current_subject?.getId()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return exercises_list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ex", for: indexPath)

        cell.textLabel?.text = exercises_list[indexPath.row].getName()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        current_exercise = exercises_list[indexPath.row]
        self.performSegue(withIdentifier: "segue_to_exercise", sender: self)
    }
}
