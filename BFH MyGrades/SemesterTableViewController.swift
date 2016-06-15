//
//  SemesterTableViewController.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 25.02.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

class SemesterTableViewController: UITableViewController {
    
    let bfhData = BFHData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bfhData.load()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SemesterTableViewController.loadList(_:)), name:"semester_loaded", object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadList(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bfhData.semester.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SemesterCell", forIndexPath: indexPath) as! SemesterTableViewCell
        let entry = bfhData.semester[indexPath.row]
        cell.nameOfSemester.text = entry.name
        cell.countOfCourses.text = "\(entry.courses.count) Kurse"
        cell.ectsPoints.text = "\(entry.ects) ECTS"
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowSemesterDetail" {
            let viewController:CoursesViewController = segue.destinationViewController as! CoursesViewController
            let indexPath = self.tableView.indexPathForSelectedRow!.row
            viewController.data =  self.bfhData.semester[indexPath]
            viewController.title = self.bfhData.semester[indexPath].name
            
        }
    }
    

}
