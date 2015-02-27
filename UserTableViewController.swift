//
//  UserTableViewController.swift
//  Instagram
//
//  Created by geine on 15/2/27.
//  Copyright (c) 2015年 isee. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    var Users = [""]
    var Following = [Bool]()
    var Refresher:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUsers()
        
        Refresher = UIRefreshControl()
        Refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        Refresher.addTarget(self, action: "pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(Refresher)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        if Following.count > indexPath.row {
            if Following[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        cell.textLabel?.text = Users[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"followers")
            query.whereKey("following", equalTo:cell.textLabel?.text)
            query.whereKey("follower", equalTo:PFUser.currentUser().username)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    for object in objects {
                        object.deleteInBackgroundWithBlock(nil)
                    }
                } else {
                    println(error)
                }
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var following = PFObject(className: "followers")
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            
            following.saveInBackgroundWithBlock(nil)
        }
    }
    
    func checkUsers() {
        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.Users.removeAll(keepCapacity: true)
            
            for obj in objects {
                var user = obj as PFUser
                var isFollowing:Bool
                if user.username != PFUser.currentUser().username {
                    self.Users.append(user.username)
                    
                    isFollowing = false
                    
                    var query = PFQuery(className:"followers")
                    query.whereKey("following", equalTo:user.username)
                    query.whereKey("follower", equalTo:PFUser.currentUser().username)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            for object in objects {
                                isFollowing = true
                            }
                            self.Following.append(isFollowing)
                            self.tableView.reloadData()
                        } else {
                            println(error)
                        }
                        
                        self.Refresher.endRefreshing()
                    }
                }
            }
        }
    }
    
    func pullToRefresh() {
        checkUsers()
    }
}
