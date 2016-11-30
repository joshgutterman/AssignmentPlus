//
//  StudentCoursesItem.swift
//  AssignmentPlusProto
//
//  Created by Kyle Fong on 11/30/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import Foundation
import Firebase

struct StudentCoursesItem{
    
    let key: String
    let course: String
    let subject: String
    let uid:String
    
    init(course: String, uid: String, subject: String, key: String = ""){
        self.key = key
        self.course = course
        self.subject = subject
        self.uid = uid
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        course = snapshotValue["course"] as! String
        subject = snapshotValue["subject"] as! String
        uid = snapshotValue["uid"] as! String
    }
    
    func toAnyObject() -> Any{
        return [
            "course": course,
            "subject": subject,
            "uid": uid
        ]
    }
}
