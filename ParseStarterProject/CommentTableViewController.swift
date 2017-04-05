//
//  CommentTableViewController.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 29.03.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

//This viewController class provides the professor with a tableView, where he/she can see all the comments for a given exercise.
class CommentTableViewController: UITableViewController {
    
    @IBOutlet var comment_popup_view: UIView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var comment_popup_textview: UITextView!
    @IBOutlet var button_popup_view: UIButton!
    var comments = [String]()
    var blurEffectView:UIVisualEffectView? = nil
    var popupViewIsUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationItem.title = current_exercise?.getName()
        self.getValidAnswers()
        comment_popup_view.layer.cornerRadius = 15
        comment_popup_textview.layer.cornerRadius = 15
        button_popup_view.layer.cornerRadius = button_popup_view.frame.size.width / 2
        button_popup_view.layer.borderWidth = 0.5
        button_popup_view.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func getValidAnswers() {
        
        for answer in current_exercise!.getAnswers() {
            
            if answer.getComment().characters.count != 0 && answer.getComment() != "" {
                
                comments.append(answer.getComment())
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment_cell", for: indexPath) as! CommentCell
        cell.label_comment.text = comments[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView,titleForHeaderInSection section:Int) ->String? {
        
        return "Student comments"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label:UILabel = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont (name: "Helvetica", size: 20)
        label.text = "Student comments"
        return label
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        comment_popup_textview.text = comments[indexPath.row]
        animateInCommentPopupView(myView: comment_popup_view, indexPath: indexPath)
    }
    
    @IBAction func hide_popup_view(_ sender: Any) {
        
        animateOutCommentPopupView(myView: comment_popup_view)
        deselectRow()
    }
    
    func deselectRow() {
        
        if tableView.indexPathForSelectedRow != nil {
         
            let indexPath  = tableView.indexPathForSelectedRow
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
    }
    
    func animateInCommentPopupView(myView:UIView, indexPath:IndexPath) {
        
        if !popupViewIsUp {
            
            popupViewIsUp = true
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            if #available(iOS 10.0, *) {
                blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.regular)
            } 
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView!.frame = view.bounds
            blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView!.tag = 0
            
            view.addSubview(blurEffectView!)
            self.view.addSubview(myView)
            let posX = self.tableView.rectForRow(at: indexPath).midX
            var posY = self.tableView.rectForRow(at: indexPath).midY
            if indexPath.row == 0 || indexPath.row == 1 {
                
                //posY += 100.0
                posY = view.center.y
            } else if indexPath.row == self.comments.count - 1 {
                
                posY -= 200
            } else if indexPath.row == self.comments.count - 2 {
                posY -= 100
            }
            let point = CGPoint(x: posX, y: posY)
            myView.center = point
            myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            myView.alpha = 0
            
            UIView.animate(withDuration: 0.4) {
                
                myView.alpha = 1
                myView.transform = CGAffineTransform.identity
            }
            self.tableView.isScrollEnabled = false
        }
    }
    
    func animateOutCommentPopupView(myView:UIView) {
        
        popupViewIsUp = false
        self.blurEffectView?.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            
            myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            myView.alpha = 0
            
        }) { (success:Bool) in
            
            myView.removeFromSuperview()
        }
        self.tableView.isScrollEnabled = true
    }
    
}
