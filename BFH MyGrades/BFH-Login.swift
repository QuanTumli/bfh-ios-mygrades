//
//  BFH-Login.swift
//  BFH MyGrades
//
//  Created by Jonas Mosimann on 28.02.16.
//  Copyright © 2016 Percori. All rights reserved.
//

import Foundation

class BFHLogin {
    var isLoggedIn = false
    
    init() {
        checkIfLoggedIn({
            self.isLoggedIn = true
        })
    }
    
    func checkIfLoggedIn(succ : () -> ()) {
        let baseURL = "https://is-a.bfh.ch/imoniteur_OPROAD/logouts.time"
        let url:NSURL = NSURL(string: baseURL)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            guard let _ = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling POST")
                print(error)
                return
            }
            let result: String = String(data: data!, encoding: NSISOLatin1StringEncoding)!
            let time: Int = Int(result.substringWithRange(result.startIndex.advancedBy(7)..<result.startIndex.advancedBy(9)))!
            if(time != -1){
                succ()
            }
        }
        task.resume()
    }
    
    func login(username : String, password : String, onLoginSuccessful: () -> ()) {
        var baseURL = "https://is-a.bfh.ch/imoniteur_OPROAD/!logins.tryToConnect?"
        baseURL.appendContentsOf("ww_x_username=\(username)&ww_x_password=\(password)")
        let url:NSURL = NSURL(string: baseURL)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            guard let _ = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling POST")
                print(error)
                return
            }
            onLoginSuccessful()
        }
        task.resume()
    }
}