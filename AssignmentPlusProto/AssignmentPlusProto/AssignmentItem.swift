//
//  AssignmentItem.swift
//  AssignmentPlusProto
//
//  Created by Kyle Fong on 11/29/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import Foundation
import Firebase

struct AssignmentItem{

    let key: String
    let assignment: String
    let due_date: String
    let details: String
    
    init(assignment: String, due_date: String, details: String, uid: String, key: String = ""){
        self.key = key
        self.assignment = assignment
        self.due_date = due_date
        self.details = details
    }

    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        assignment = snapshotValue["assignment"] as! String
        due_date = snapshotValue["due_date"] as! String
        details = snapshotValue["details"] as! String
    }
    
    func toAnyObject() -> Any{
        return[
           "assignment": assignment,
            "due_date": due_date,
            "details": details
        ]
    }
}
