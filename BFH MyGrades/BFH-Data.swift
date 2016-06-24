//
//  BFH-Data.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 26.02.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import Foundation

class BFHData: NSObject, NSXMLParserDelegate {
    
    var semester = [Semester]()
    var statistic = Statistic()
    
    var insideLink = false
    var semesterString = ""
    var semesterId = ""
    
    var insideTr = false
    var insideTd = false
    var countOfTd = 0
    var courseTitle = ""
    var courseCode = ""
    var courseGrade = ""
    
    var courseDataLoaded = false
    
    static let sharedInstance = BFHData()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    func load(){
        if(!courseDataLoaded){
            self.loadData("https://is-a.bfh.ch/imoniteur_OPROAD/!PORTAL1S.portalCell?ww_k_cell=2066908133", onCompletion: { result, data in
                let xmlParser = NSXMLParser(data: data)
                xmlParser.delegate = self
                xmlParser.parse()
            })
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName == "link"){
            insideLink = true
            semesterId = attributeDict["id"]!.componentsSeparatedByString("&")[0]
        }
        if(elementName == "tr"){
            insideTr = true
        }
        if(insideTr && elementName == "td"){
            insideTd = true
        }
        if(elementName == "input"){
            semesterId = "ww_i_inscription=" + attributeDict["value"]!
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if insideLink {
            semesterString = semesterString + string
        }
        if insideTr && insideTd {
            switch countOfTd {
            case 0:
                courseTitle = courseTitle + string
            case 1:
                courseCode = courseCode + string
            case 2:
                courseGrade = courseGrade + string
            default: break
            }
            
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "link"){
            insideLink = false
            if(semesterString != ""){
                var myStringArr = semesterString.componentsSeparatedByString(", ")
                semester.append(Semester(name: "\(myStringArr[0]) \(myStringArr[1]) \(myStringArr[2])",
                    id: semesterId))
                semesterString = ""
                semesterId = ""
            }
        }
        if(elementName == "tr"){
            //print("..finished tr")
            insideTr = false
            countOfTd = 0
            if(courseTitle != "" && courseCode != ""){
                let course = Course(title: courseTitle, code: courseCode, grade: courseGrade)
                for i in 0 ..< semester.count  {
                    if(semester[i].id == semesterId){
                        semester[i].addCourse(course)
                    }
                }
                //courseData.append((title: courseTitle, code: courseCode, grade: courseGrade))
                courseTitle = ""
                courseCode = ""
                courseGrade = ""
            }
        }
        if(elementName == "td"){
            insideTd = false
            countOfTd += 1
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if(!courseDataLoaded){
            for i in 0 ..< semester.count  {
                loadData("https://is-a.bfh.ch/imoniteur_OPROAD/!PORTAL1S.portalCell?ww_k_cell=570281154&" + semester[i].id, onCompletion: { result, data in
                    let xmlParser = NSXMLParser(data: data)
                    xmlParser.delegate = self
                    xmlParser.parse()
                })
            }
            courseDataLoaded = true
        }
        self.calculateECTS()
        
        NSNotificationCenter.defaultCenter().postNotificationName("semester_loaded", object: nil)
    }
    
    //TODO: is called multiple times... has to be fixed!
    func calculateECTS(){
        statistic = Statistic()
        for i in 0 ..< semester.count  {
            semester[i].ects = 0
            for j in 0 ..< semester[i].courses.count  {
                semester[i].ects += semester[i].courses[j].ects
                switch(semester[i].courses[j].group){
                case "A": statistic.addECTStoGroupA(semester[i].courses[j].ects)
                case "B": statistic.addECTStoGroupB(semester[i].courses[j].ects)
                case "C": statistic.addECTStoGroupC(semester[i].courses[j].ects)
                case "D": statistic.addECTStoGroupD(semester[i].courses[j].ects)
                default: break
                }
            }
            
        }
    }
    
    func loadData(url: String, onCompletion: (result: String, data: NSData) -> ()) {
        var responseString : String = ""
        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
    
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        //request.addValue(cookie, forHTTPHeaderField: "Cookie")
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            guard let _ = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET")
                print(error)
                return
            }
            responseString = String(data: data!, encoding: NSISOLatin1StringEncoding)!
            onCompletion(result: responseString, data: data!)
        }
        task.resume()
    }
    
    class Statistic {
        var totalECTS = 0
        var groupA = [String: Int]()
        var groupB = [String: Int]()
        var groupC = [String: Int]()
        var groupD = [String: Int]()
        
        init() {
            self.groupA["min"] = 48
            self.groupA["max"] = 54
            self.groupA["earned"] = 0
            self.groupB["min"] = 48
            self.groupB["max"] = 54
            self.groupB["earned"] = 0
            self.groupC["min"] = 52
            self.groupC["max"] = 58
            self.groupC["earned"] = 0
            self.groupD["min"] = 14
            self.groupD["max"] = 28
            self.groupD["earned"] = 0
        }
        
        func addECTStoGroupA(ects : Int) {
            self.groupA["earned"]! += ects
            self.calcTotal()
        }
        
        func addECTStoGroupB(ects : Int) {
            self.groupB["earned"]! += ects
            self.calcTotal()
        }
        
        func addECTStoGroupC(ects : Int) {
            self.groupC["earned"]! += ects
            self.calcTotal()
        }
        
        func addECTStoGroupD(ects : Int) {
            self.groupD["earned"]! += ects
            self.calcTotal()
        }
        
        func calcTotal() {
            self.totalECTS = self.groupA["earned"]! + self.groupB["earned"]! + self.groupC["earned"]! + self.groupD["earned"]!
        }
        
        
    }
    
    class Semester {
        let name : String
        let id : String
        var ects : Int
        var courses:[Course]
        
        init(name : String, id : String) {
            self.name = name
            self.id = id
            self.ects = 0
            self.courses = []
        }
        
        init(){
            self.name = ""
            self.id = ""
            self.ects = 0
            self.courses = []
        }
        
        func addCourse(course: Course) {
            self.courses.append(course)
        }
    }
    
    static let courses: [String:(ects : Int, group : String)] = [
        "BZG1181": (ects : 6, group : "A"),
        "BZG1182": (ects : 6, group : "A"),
        "BTX8051": (ects : 6, group : "A"),
        "BTX8052": (ects : 4, group : "A"),
        "BTX8053": (ects : 6, group : "A"),
        "BTX8054": (ects : 4, group : "A"),
        "BTX8061": (ects : 6, group : "A"),
        "BTX8062": (ects : 4, group : "A"),
        "BTX8065": (ects : 2, group : "A"),
        "BTX8071": (ects : 4, group : "A"),
        "BTX8081": (ects : 6, group : "A"),
        
        "BTX8001": (ects : 6, group : "B"),
        "BTX8002": (ects : 6, group : "B"),
        "BTX8003": (ects : 2, group : "B"),
        "BTX8004": (ects : 4, group : "B"),
        "BTX8005": (ects : 4, group : "B"),
        "BTX8011": (ects : 4, group : "B"),
        "BTX8012": (ects : 4, group : "B"),
        "BTX8015": (ects : 4, group : "B"),
        "BTX8016": (ects : 4, group : "B"),
        "BTX8021": (ects : 4, group : "B"),
        "BTX8022": (ects : 4, group : "B"),
        "BTX8025": (ects : 2, group : "B"),
        "BTX8026": (ects : 2, group : "B"),
        "BTX8027": (ects : 2, group : "B"),
        "BTX8030": (ects : 2, group : "B"),
        
        "BZG3101": (ects : 2, group : "C"),
        "BZG3102": (ects : 2, group : "C"),
        "BZG3411": (ects : 2, group : "C"),
        "BZG3412": (ects : 2, group : "C"),
        "BTX8111": (ects : 2, group : "C"),
        "BTX8112": (ects : 2, group : "C"),
        "BTX8113": (ects : 4, group : "C"),
        "BTX8201": (ects : 6, group : "C"),
        "BTX8202": (ects : 6, group : "C"),
        "BTX8101": (ects : 4, group : "C"),
        "BTX8102": (ects : 4, group : "C"),
        "BTX8105": (ects : 4, group : "C"),
        "BTX8108": (ects : 6, group : "C"),
        "BZG3423": (ects : 2, group : "C"),
        
        "BTI7532": (ects : 2, group : "D"),
        "BTI7083": (ects : 4, group : "D"),
        "BZG3207": (ects : 2, group : "D"),
        "BZG3208": (ects : 2, group : "D"),
        "BTI7528": (ects : 2, group : "D"),
        "BTX8504": (ects : 2, group : "D"),
        "BTI7529": (ects : 2, group : "D"),
        "BTI7535": (ects : 2, group : "D"),
        "BTI7538": (ects : 2, group : "D")
    ]
    
    class Course {
        let title : String
        let code: String
        let grade: String
        let group: String
        let ects: Int
        
        init(title: String, code: String, grade: String){
            self.title = title
            self.code = code
            self.grade = grade
            if let course = BFHData.courses[code] {
                self.group = course.group
                self.ects = course.ects
            }else{
                self.group = "?"
                self.ects = 0
            }
            
        }
    }
    
    
   
}