//
//  CoursesViewController.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 25.02.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate {

    var data = BFHData.Semester()
    var ectsTotal = 0
    let colorPassed = UIColor(red: 178/255.0, green: 224/255.0, blue: 151/255.0, alpha: 1)
    let colorFailed = UIColor(red: 210/255.0, green: 67/255.0, blue: 53/255.0, alpha: 1)
    let colorNotGraded = UIColor(red: 255/255.0, green: 233/255.0, blue: 173/255.0, alpha: 1)
    
    @IBOutlet weak var coursesCount: UILabel!
    @IBOutlet weak var ectsEarned: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.coursesCount.text = String(data.courses.count)
        for c in data.courses {
            self.ectsTotal += c.ects
        }
        self.ectsEarned.text = "\(self.ectsTotal)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! CoursesTableViewCell
        let d = data.courses[indexPath.row]
        cell.courseName.text = d.title
        cell.courseDetails.text = "\(d.group) - \(d.code)"
        cell.ectsPoints.text = String(d.ects)
        cell.grade.text = d.grade
        if (d.grade == "Fx" || d.grade == "F") {
            cell.backgroundColor = colorFailed
        }else if (d.grade == "***") {
            cell.backgroundColor = colorNotGraded
        }else{
            cell.backgroundColor = colorPassed
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

}
