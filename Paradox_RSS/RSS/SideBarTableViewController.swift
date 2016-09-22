//
//  SideBarTableViewController.swift
//  BlurSlider
//
//  Created by Austin Eckman on 1/21/15.
//  Copyright (c) 2015 Austin Eckman. All rights reserved.
//

import UIKit
import CoreData


protocol SideBarTableViewControllerDelegate{
    func sideBarControlDidSelectRow(indexPath:NSIndexPath)
}

class SideBarTableViewController: UITableViewController {
    
    var delegate:SideBarTableViewControllerDelegate?
    var tableData:Array<String> = []
    
    
    // MARK: - Table view data source
 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            // Configure the cell...
            
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.textColor = UIColor.darkTextColor()
            
           //Cell height and settings
            let selectedView:UIView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            
            selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        //Get textlabel from tableData
        cell?.textLabel?.text = tableData[indexPath.row]
        if indexPath.row < 2{//Bold first two rows
            cell?.textLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        }
        
        
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0 //Cell height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Did select row at index path
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        delegate?.sideBarControlDidSelectRow(indexPath)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row > 1{ //Only edit the non default rows (Add feed and favorites)
            return true
        }else{
            return false
        }
        
    }
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            //Contact core data to delete row
            
            let moc = SwiftCoreDataHelper.managedObjectContext()
            if let results = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Feed), withPredicate: nil, managedObjectContext: moc) as? [Feed]{
            let logItemToDelete = results[indexPath.row - 2] as NSManagedObject
            moc.deleteObject(logItemToDelete)
            tableData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            SwiftCoreDataHelper.saveManagedObjectContext(moc)
            }
            
            
        }
    }
}
