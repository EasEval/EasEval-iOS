//
//  ViewControllerAbout.swift
//  PUProject
//
//  Created by August Lund Eilertsen on 22.03.2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ViewControllerAbout: UIViewController, UIWebViewDelegate {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var segmentControl: UISegmentedControl!
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet var webView: UIWebView!
    
    var infoFile:PFFile! = nil
    var mLicense_file:PFFile! = nil
    var cLicense_file:PFFile! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationItem.title = "EasEval"
        getInfoFiles()
    }
    
    func getInfoFiles() {
        
        runActivityIndicator()
        let query = PFQuery(className: "Info")
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                self.infoFile = objects?[0]["INFO"] as! PFFile
                self.mLicense_file = objects?[0]["mLICENSE"] as! PFFile
                self.cLicense_file = objects?[0]["cLICENSE"] as! PFFile
                
                self.infoFile.getPathInBackground(block: { (path, error) in
                    
                    if error == nil {
                        
                        let infoUrl = NSURL(fileURLWithPath: path!)
                        print(infoUrl)
                        let request = NSURLRequest(url: infoUrl as URL)
                        self.webView.loadRequest(request as URLRequest)
                    }
                })
            }
            
            self.stopActivityIndicator()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebView(path:String) {
        
        let infoUrl = NSURL(fileURLWithPath: path)
        let request = NSURLRequest(url: infoUrl as URL)
        self.webView.loadRequest(request as URLRequest)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        let licenses = [infoFile, mLicense_file, cLicense_file]
        
        licenses[segmentControl.selectedSegmentIndex%licenses.count]!.getPathInBackground(block: { (path, error) in
            
            if error == nil {
                
                self.loadWebView(path: path!)
            }
        })
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        stopActivityIndicator()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
        runActivityIndicator()
    }
    
    func runActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func stopActivityIndicator() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }


}
