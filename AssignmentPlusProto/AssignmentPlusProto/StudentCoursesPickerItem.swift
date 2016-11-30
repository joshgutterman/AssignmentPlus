//
//  studentCoursesPickerItem.swift
//  AssignmentPlusProto
//
//  Created by Kyle Fong on 11/30/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import Foundation
import Firebase

struct StudentCoursesPickerItem{

    let key: String
    let added_by: String
    let course: String
    let period: String
    let school_term: String
    let uid:String
    
    init(added_by: String, course: String, period: String, school_term: String, uid: String, key: String = ""){
        self.key = key
        self.added_by = added_by
        self.course = course
        self.period = period
        self.school_term = school_term
        self.uid = uid
    }
    
    init(snapshot:FIRDataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        added_by = snapshotValue["added_by"] as! String
        course = snapshotValue["course"] as! String
        period = snapshotValue["period"] as! String
        school_term = snapshotValue["school_term"] as! String
        uid = snapshotValue["uid"] as! String
    }
    
    func toAnyObject() -> Any{
        return[
            "added_by": added_by,
            "course": course,
            "period": period,
            "school_term": school_term,
            "uid": uid
        ]
    }
}
