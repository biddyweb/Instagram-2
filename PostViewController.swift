//
//  PostViewController.swift
//  Instagram
//
//  Created by geine on 15/2/27.
//  Copyright (c) 2015年 isee. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var PhotoSelected = false
    
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var ShareText: UITextField!

    @IBAction func chooseImagePress(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    @IBAction func postImagePress(sender: AnyObject) {
        var error = ""
        if !PhotoSelected {
            error = "Please select an image to post."
        } else if (ShareText.text == "") {
            error = "Please enter a message."
        }
        
        if error != "" {
            displayAlert("Cannot Post Image", error: error)
        } else {
            var post = PFObject(className: "Post")
            post["Title"] = ShareText.text
            post["Username"] = PFUser.currentUser().username
            
            post.saveInBackgroundWithBlock({ (success, err) -> Void in
                if success {
                    let imageData = UIImagePNGRepresentation(self.ImageView.image)
                    let imageFile = PFFile(name: "iamge.png", data: imageData)
                    post["ImageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock({ (suc, errMsg) -> Void in
                        if suc {
                            self.displayAlert("Image Posted", error: "Your image has been posted successfully!")
                            
                            self.PhotoSelected = false
                            self.ImageView.image = nil
                            self.ShareText.text = ""
                        } else {
                            self.displayAlert("Could Not Post Image", error: "Please try again later.")
                        }
                    })
                } else {
                    self.displayAlert("Could Not Post Image", error: "Please try again later.")
                }
            })
        }
    }
    
    
    @IBAction func logoutPress(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title:String?, error:String?) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        ImageView.image = image
        PhotoSelected = true
    }

}
