//
//  ExercisesTableViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

var current_exercise:Exercise? = nil

class ExercisesTableViewController: UITableViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    var exercisesList = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = current_subject?.getId()
        getExercises()

    }
    
    func getExercises() {
        
        let exQuery = PFQuery(className: "Exercises")
       
        //exQuery.whereKey("SUBJECTID", matchesKey: "ID", in: subQuery)
        exQuery.whereKey("SUBJECTID", equalTo: current_subject!.getId())
        exQuery.addAscendingOrder("NAME")
        exQuery.findObjectsInBackground { (objects, error) in
            
            if error == nil {
             
                if let objects = objects {
                    
                    var checkList = [String]()
                    for object in objects {
                        
                        let id = object.objectId
                        let name = object["NAME"] as! String
                        let subID = object["SUBJECTID"] as! String
                        
                        if !checkList.contains(name) {
                            
                            let newExercise = Exercise(id: id!, name: name, subId: subID)
                            self.exercisesList.append(newExercise)
                            // Add all values to each exercise
                            checkList.append(name)
                        }
                    
                        
                    }
                    
                    self.tableView.reloadData()
                }
            } else {
                
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercisesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ex", for: indexPath)

        cell.textLabel?.text = exercisesList[indexPath.row].getName()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        current_exercise = exercisesList[indexPath.row]
        self.performSegue(withIdentifier: "segue_to_exercise", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
