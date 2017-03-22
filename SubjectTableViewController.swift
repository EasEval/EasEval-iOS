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

protocol listListener {
    
    func callAnimOut()
}

class addNewSubjectView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var subjectData = [Subject]()
    var list_listener:listListener? = nil
    
    func registerListener(listener:listListener) {
        
        self.list_listener = listener
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subjectData.count
    }
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     
     return "Fag"
     }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSubject_cell", for: indexPath) as! SubjectCell
        
        cell.labelSubjectCode.text = subjectData[indexPath.row].getId() + ": "
        cell.labelSubjectName.text = subjectData[indexPath.row].getName()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newObject = PFObject(className: "HasSubject")
        newObject["USERID"] = PFUser.current()
        let query = PFQuery(className: "Subjects")
        query.whereKey("objectId", equalTo: self.subjectData[indexPath.row].getObjectId())
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                if let subjects = objects {
                    
                    let subject = subjects[0]
                    newObject["SUBCODE"] = subject
                    newObject.saveEventually()
                    
                }
                self.list_listener?.callAnimOut()
            } else {
                
                self.list_listener?.callAnimOut()
            }
        }
    }
}

class SubjectTableViewController: UITableViewController, listListener {
    
    internal func callAnimOut() {
        
        animateOut()
        let newTimer : Timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timer_func), userInfo: nil, repeats: false)
        newTimer.accessibilityActivate()
    }
    
    func timer_func() {
        
        downloadSubjectList()
    }

    @IBOutlet var barButton_logout: UIBarButtonItem!
    var activityIndicator = UIActivityIndicatorView()
    var blurEffectView:UIVisualEffectView? = nil
    @IBOutlet var tableViewAddSubject: UITableView!
    
    @IBOutlet var addSubjectView: addNewSubjectView!
    
    @IBAction func actionLogout(_ sender: Any) {
        
        logoutAlert("Logg ut", message: "Ønsker du å logge ut?", view: self)
    }
    
    func logout() {
        
        PFUser.logOut()
        self.performSegue(withIdentifier: "segue_logout_from_subjects", sender: self)
    }
    
    func logoutAlert(_ title: String, message: String, view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Logg ut", style: .default, handler: { (action) -> Void in
            
            self.logout()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Avbryt", style: .default, handler: nil))
        
        view.present(alert, animated: true, completion: nil)
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
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func animateIn() {
        
        //resetAlphas()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.frame = view.bounds
        blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView!.tag = 0
        view.addSubview(blurEffectView!)
        self.tableView.allowsSelection = false
        
        self.addSubjectView.subjectData.removeAll()
        self.addSubjectView.registerListener(listener: self)
        self.addSubjectView.reloadInputViews()
        self.addSubjectView.layer.cornerRadius = 15
        self.addSubjectView.isUserInteractionEnabled = true
        self.view.addSubview(addSubjectView)
        addSubjectView.center = self.view.center
        
        addSubjectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addSubjectView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            
            //self.visualEffectView.effect = self.effect
            self.addSubjectView.alpha = 1
            self.addSubjectView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        
        self.blurEffectView?.removeFromSuperview()
        self.tableView.allowsSelection = true
        UIView.animate(withDuration: 0.3, animations: {
            
            self.addSubjectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addSubjectView.alpha = 0
            
            //self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            
            self.addSubjectView.removeFromSuperview()
        }
    }
    
    @IBAction func cancelAddSubject(_ sender: Any) {
        
        animateOut()
    }
    
    func downloadAllSubjects() {
        
        let subjectQuery = PFQuery(className: "Subjects")
        //subjectQuery.whereKey("USERID", notEqualTo: PFUser.current() ?? 0)
        //subjectQuery.includeKey("SUBCODE")             
        subjectQuery.addAscendingOrder("NAME")
        subjectQuery.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                for object in objects! {
                    
                    
                    let subjectId = object["ID"] as! String
                    let subjectName = object["NAME"] as! String
                    let objectId = object.objectId!
                    
                    if !subjectList.contains(where: { $0.objectId == objectId }) {
                        
                        let newSubject = Subject(id: subjectId, name: subjectName, objectId: objectId)
                        self.addSubjectView.subjectData.append(newSubject)
                    }
                    
                }
            }
            self.tableViewAddSubject.reloadData()
        }
        
        
    }
    
    @IBAction func addSubject(_ sender: Any) {
        
        downloadAllSubjects()
        animateIn()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadSubjectList()
        
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("DEL")
            
            let subject_query = PFQuery(className: "Subjects")
            let delete_query = PFQuery(className: "HasSubject")
            subject_query.whereKey("objectId", equalTo: subjectList[indexPath.row].getObjectId())
            subject_query.findObjectsInBackground(block: { (objects, error) in
                
                if error == nil {
                    
                    if let objects = objects {
                        
                        let subject = objects[0]
                        delete_query.whereKey("USERID", equalTo: PFUser.current() ?? 0)
                        delete_query.whereKey("SUBCODE", equalTo: subject)
                        delete_query.findObjectsInBackground(block: { (objects, error) in
                            
                            if error == nil {
                            
                                if let deleteObjects = objects {
                                    
                                    deleteObjects[0].deleteInBackground()
                                    subjectList.remove(at: indexPath.row)
                                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                                    //self.tableView.reloadData()
                                }
                            }
                        })
                        
                    }
                }
            })
            
            
        }
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
