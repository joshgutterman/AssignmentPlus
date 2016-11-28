//
//  CourseItem.swift
//  AssignmentPlusProto
//
//  Created by Kyle Fong on 11/27/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import Foundation
import Firebase

struct CoursesItem{

    let key: String
    let course: String
    let period: String
    let school_term: String
    
    init(course: String, period: String, school_term: String, key: String = ""){
        self.key = key
        self.course = course
        self.period = period
        self.school_term = school_term

    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        course = snapshotValue["course"] as! String
        period = snapshotValue["period"] as! String
        school_term = snapshotValue["school_term"] as! String
    }
 
    func toAnyObject() -> Any{
        return [
            "course": course,
            "period": period,
            "school_term": school_term
        ]
    }
}
