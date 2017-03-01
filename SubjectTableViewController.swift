//
//  SubjectTableViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 15.02.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

var selectedSubject = 0
var subjectList = [Subject]()

class SubjectTableViewController: UITableViewController {

    @IBOutlet var barButton_logout: UIBarButtonItem!
    var activityIndicator = UIActivityIndicatorView()

    
    @IBAction func actionLogout(_ sender: Any) {
        
        PFUser.logOut()
        let currentUser = PFUser.current()
        if currentUser == nil {
            
            print("Logout succeeded")
        }
        self.performSegue(withIdentifier: "segue_logout_from_subjects", sender: self)
    }
    
    func downloadSubjectList() {
        
        startActivityIndicator()
        
        let hasSubjectQuery = PFQuery(className: "HasSubject")
        hasSubjectQuery.whereKey("USERID", equalTo: PFUser.current() ?? 0)
        hasSubjectQuery.includeKey("SUBCODE")
        hasSubjectQuery.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                subjectList.removeAll()
                if let objects = objects {
                    
                    for object in objects {
                        
                        
                        if let subject = object["SUBCODE"] as? PFObject {
                            
                            let subjectId = subject["ID"] as! String
                            let subjectName = subject["NAME"] as! String
                            let objectId = subject.objectId!
                            let newSubject = Subject(id: subjectId, name: subjectName, objectId: objectId)
                            subjectList.append(newSubject)
                        }
                    }
                }
                self.stopActivityIndicator()
                self.tableView.reloadData()
            } else {
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func startActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadSubjectList()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return subjectList.count
    }
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Fag"
    }*/

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectCell
        
        cell.labelSubjectCode.text = subjectList[indexPath.row].getId() + ": "
        cell.labelSubjectName.text = subjectList[indexPath.row].getName()

    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedSubject = indexPath.row
        self.performSegue(withIdentifier: "segue_to_subject", sender: self)
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
