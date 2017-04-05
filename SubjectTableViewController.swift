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
    
    //This class is the controller that controls the popupview when you press the + button in the navigation bar. The controller to add a new subject. 
    //All the functons that starts with 'tableView', is default functions that comes with the tableView class. 
    //The 'cellForRowAt' function returns the proper cell for each row in the tableview. 
    //The other tableView functions are self-explanatory
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSubject_cell", for: indexPath) as! SubjectCell
        
        cell.labelSubjectCode.text = subjectData[indexPath.row].getId()
        cell.labelSubjectName.text = subjectData[indexPath.row].getName()
        return cell
    }
    
    //This function get called when you press a cell in the tableView
    //It crates a query, finds the proper subject in the database, and ads a relation between this subject and the professor that select it. The subject will then show up in the subjectlist
    
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
    
    //This class is the viewController for the professors subjectlist.
    //The tableview in this class directs the professor to the given subject
    //This class implements a custom made protocol/interface, which works as a listener for the popupview.
    
    //This function comes with the listListener, and it is called from the popupView where you add a new subject. This function animatea out and removes the popupView. The timer just ads a delay, for security purposes
    internal func callAnimOut() {
        
        animatePopupOut(myView: self.addSubjectView)
        let newTimer : Timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timer_func), userInfo: nil, repeats: false)
        newTimer.accessibilityActivate()
    }
    
    func timer_func() {
        
        downloadSubjectList()
    }

    //GUI references
    @IBOutlet var barButton_logout: UIBarButtonItem!
    var activityIndicator = UIActivityIndicatorView()
    var blurEffectView:UIVisualEffectView? = nil
    @IBOutlet var tableViewAddSubject: UITableView!
    @IBOutlet var addSubjectView: addNewSubjectView!
    @IBOutlet var swipeInfoView: UIView!
    
    @IBAction func actionLogout(_ sender: Any) {
        
        logoutAlert("Logout", message: "Sure you want to logout?", view: self)
    }
    
    func logout() {
        
        PFUser.logOut()
        self.performSegue(withIdentifier: "segue_logout_from_subjects", sender: self)
    }
    
    func logoutAlert(_ title: String, message: String, view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            
            self.logout()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    func badConnectionAlert(_ title: String, message: String, view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action) -> Void in
            
            self.downloadSubjectList()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
            self.performSegue(withIdentifier: "segue_logout_from_subjects", sender: self)
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
    
    // This function downloads all the subject related to the logged in professor. These subjects will appear in the tableView.
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
                self.badConnectionAlert("Error", message: "Couldn´t login. Check your connection and try again", view: self)
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
    
    //When the view appears, this function animates a info view in for some seconds, and removes it afterwards
    func animateSwipeInfoIn() {
        
        self.view.addSubview(swipeInfoView)
        swipeInfoView.center = self.view.center
        swipeInfoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        swipeInfoView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            //self.visualEffectView.effect = self.effect
            self.swipeInfoView.alpha = 1
            self.swipeInfoView.transform = CGAffineTransform.identity
        }
    }
    
    //Animates the 'addNewSubject' popupview in to the viewController
    func animatePopupIn() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.frame = view.bounds
        blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView!.tag = 0
        view.addSubview(blurEffectView!)
        self.tableView.allowsSelection = false
        
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
    
    //Animates out the info view and removes it from the viewcontroller
    func animateOutSwipeInfo() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.swipeInfoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.swipeInfoView.alpha = 0
            
        }) { (success:Bool) in
            
            self.swipeInfoView.removeFromSuperview()
        }
    }
    
    //Animates the 'addNewSubject' view out and removes it
    func animatePopupOut(myView:UIView) {
        
        self.blurEffectView?.removeFromSuperview()
        self.tableView.allowsSelection = true
        UIView.animate(withDuration: 0.3, animations: {
            
            myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            myView.alpha = 0
            
        }) { (success:Bool) in
            
            myView.removeFromSuperview()
        }
    }
    
    @IBAction func cancelAddSubject(_ sender: Any) {
        
        animatePopupOut(myView: self.addSubjectView)
    }
    
    //This function downloads all the subject NOT related to the logged in professor. 
    //Theese subject will appear in the 'addSubject' popupview so that the professor can add one of theese subjects
    func downloadSubjectsToPopupView() {
        
        startActivityIndicator()
        let subjectQuery = PFQuery(className: "Subjects")
        subjectQuery.addAscendingOrder("NAME")
        subjectQuery.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                self.addSubjectView.subjectData.removeAll()
                for object in objects! {
                    
                    let subjectId = object["ID"] as! String
                    let subjectName = object["NAME"] as! String
                    let objectId = object.objectId!
                    
                    if !subjectList.contains(where: { $0.objectId == objectId }) {
                        
                        let newSubject = Subject(id: subjectId, name: subjectName, objectId: objectId)
                        self.addSubjectView.subjectData.append(newSubject)
                    }
                }
                self.stopActivityIndicator()
                self.animatePopupIn()
            } else {
                
                self.stopActivityIndicator()
            }
            self.tableViewAddSubject.reloadData()
        }
    }
    
    @IBAction func addSubject(_ sender: Any) {
        
        downloadSubjectsToPopupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeInfoView.layer.cornerRadius = swipeInfoView.frame.size.height/2
        animateSwipeInfoIn()
        let newTimer : Timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(removeSwipeInfo), userInfo: nil, repeats: false)
        newTimer.accessibilityActivate()
        downloadSubjectList()
    }
    
    func removeSwipeInfo() {
        
        animateOutSwipeInfo()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return subjectList.count
    }
    
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
        
        //The function for swipe-left deletion of a subject
        if editingStyle == .delete {
            
            self.startActivityIndicator()
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
                                self.stopActivityIndicator()
                            }
                        })
                    }
                } else {
                    
                    self.stopActivityIndicator()
                }
            })
        }
    }
}
