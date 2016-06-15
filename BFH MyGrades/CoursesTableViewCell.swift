//
//  CoursesTableViewCell.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 25.02.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseDetails: UILabel!
    @IBOutlet weak var ectsPoints: UILabel!
    @IBOutlet weak var grade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
