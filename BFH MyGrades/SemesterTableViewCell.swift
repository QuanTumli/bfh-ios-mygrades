//
//  SemesterTableViewCell.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 25.02.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

class SemesterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameOfSemester: UILabel!
    @IBOutlet weak var countOfCourses: UILabel!
    @IBOutlet weak var ectsPoints: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
