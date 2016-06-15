//
//  StatViewController.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 01.03.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import UIKit

class StatViewController: UIViewController {
    @IBOutlet weak var totalECTS: UILabel!
    @IBOutlet weak var totalPercent: UILabel!
    @IBOutlet weak var progressBar: ProgressBarView!
    @IBOutlet weak var viewGroupA: CircleView!
    @IBOutlet weak var viewGroupB: CircleView!
    @IBOutlet weak var viewGroupC: CircleView!
    @IBOutlet weak var viewGroupD: CircleView!
    @IBOutlet weak var viewLabelA: UILabel!
    @IBOutlet weak var ectsAEarned: UILabel!
    @IBOutlet weak var ectsAMinMax: UILabel!
    @IBOutlet weak var viewLabelB: UILabel!
    @IBOutlet weak var ectsBEarned: UILabel!
    @IBOutlet weak var ectsBMinMax: UILabel!
    @IBOutlet weak var viewLabelC: UILabel!
    @IBOutlet weak var ectsCEarned: UILabel!
    @IBOutlet weak var ectsCMinMax: UILabel!
    @IBOutlet weak var viewLabelD: UILabel!
    @IBOutlet weak var ectsDEarned: UILabel!
    @IBOutlet weak var ectsDMinMax: UILabel!
    
    let data = BFHData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalECTS.text = "\(data.statistic.totalECTS)"
        let percent = CGFloat(round(CGFloat(data.statistic.totalECTS)/180*100*100)/100)
        totalPercent.text = "\(percent)"
        progressBar.percent = percent
        
        viewGroupA.percent = CGFloat(data.statistic.groupA["earned"]!) / CGFloat(data.statistic.groupA["min"]!) * 100
        viewLabelA.text = "A"
        ectsAEarned.text = "\(data.statistic.groupA["earned"]!) ECTS"
        ectsAMinMax.text = "min \(data.statistic.groupA["min"]!)  | max \(data.statistic.groupA["max"]!)"
        
        viewGroupB.percent = CGFloat(data.statistic.groupB["earned"]!) / CGFloat(data.statistic.groupB["min"]!) * 100
        viewLabelB.text = "B"
        ectsBEarned.text = "\(data.statistic.groupB["earned"]!) ECTS"
        ectsBMinMax.text = "min \(data.statistic.groupB["min"]!)  | max \(data.statistic.groupB["max"]!)"
        
        viewGroupC.percent = CGFloat(data.statistic.groupC["earned"]!) / CGFloat(data.statistic.groupC["min"]!) * 100
        viewLabelC.text = "C"
        ectsCEarned.text = "\(data.statistic.groupC["earned"]!) ECTS"
        ectsCMinMax.text = "min \(data.statistic.groupC["min"]!)  | max \(data.statistic.groupC["max"]!)"
        
        viewGroupD.percent = CGFloat(data.statistic.groupD["earned"]!) / CGFloat(data.statistic.groupD["min"]!) * 100
        viewLabelD.text = "D"
        ectsDEarned.text = "\(data.statistic.groupD["earned"]!) ECTS"
        ectsDMinMax.text = "min \(data.statistic.groupD["min"]!)  | max \(data.statistic.groupD["max"]!)"
        
    }
    
}
