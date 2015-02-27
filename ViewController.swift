//
//  ViewController.swift
//  Instagram
//
//  Created by geine on 15/2/26.
//  Copyright (c) 2015年 isee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var ActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var SignUpActive = true
    
    @IBOutlet var UserName: UITextField!
    @IBOutlet var Password: UITextField!
    @IBOutlet var SignUpLabel: UILabel!
    @IBOutlet var AlreadyRegLabel: UILabel!
    @IBOutlet var SignUpButton: UIButton!
    @IBOutlet var SignUpToggleButton: UIButton!
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        if SignUpActive {
            SignUpActive = false
            SignUpLabel.text = "Use the form below to log in"
            SignUpButton.setTitle("Log In", forState: UIControlState.Normal)
            AlreadyRegLabel.text = "Not Registered?"
            SignUpToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
        } else {
            SignUpActive = true
            SignUpLabel.text = "Use the form below to sign up"
            SignUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            AlreadyRegLabel.text = "Already Registered?"
            SignUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        var error = ""
        
        if UserName.text == "" || Password.text == "" {
            error = "Please enter a username and password."
        }
        
        if error != "" {
            displayAlert("Error In Form", error: error)
        } else {
            if SignUpActive {
                userSignUp()
            } else {
                userLogIn()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("JumpToUserTable", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title:String?, error:String?) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func beginActivity() {
        ActivityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        ActivityIndicator.center = self.view.center
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(ActivityIndicator)
        ActivityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func stopActivity() {
        ActivityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    func createTestObj() {
        var testObject = PFObject(className: "testObject")
        testObject.setObject("bar", forKey: "foo")
        testObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("Object created with ID: \(testObject.objectId)")
            } else {
                println(error)
            }
        }

    }

    func changeTestObj() {
        var query = PFQuery(className: "testObject")
        query.getObjectInBackgroundWithId("6RvUmWpJoX", block: { (obj: PFObject!, error) -> Void in
            if (error == nil) {
                obj["foo"] = "testShow"
                obj.saveInBackgroundWithBlock({ (success, error) -> Void in
                    
                })
            } else {
                println(error)
            }
        })
    }
    
    func userSignUp() {
        var user = PFUser()
        user.username = UserName.text
        user.password = Password.text
        
        beginActivity()
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, signupError: NSError!) -> Void in
            
            self.stopActivity()
            
            if signupError == nil {
                // Hooray! Let them use the app now.
            } else {
                var error = ""
                if let errorString = signupError.userInfo?["error"] as? NSString {
                    error = errorString
                } else {
                    error = "Please try again later."
                }
                
                self.displayAlert("Could Not Sign Up", error: error)
            }
        }
    }
    
    func userLogIn() {
        beginActivity()
        
        PFUser.logInWithUsernameInBackground(UserName.text, password:Password.text) {
            (user: PFUser!, err: NSError!) -> Void in
            
            self.stopActivity()
            
            if user != nil {
                // Do stuff after successful login.
                println("Logged in!")
            } else {
                // The login failed. Check error to see why.
                var error = ""
                if let errorString = err.userInfo?["error"] as? NSString {
                    error = errorString
                } else {
                    error = "Please try again later."
                }
                
                self.displayAlert("Could Not Log In", error: error)
            }
        }
    }
}

