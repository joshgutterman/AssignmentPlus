//
//  studentClassViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/29/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class studentClassViewController: UIViewController, UITableViewDelegate {
    
    var subjectValue:String = ""
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    var schoolValue:String = ""
    
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentSubjectViewController = storyBoard.instantiateViewController(withIdentifier: "studentSubject") as! studentSubjectViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(subjectValue)
        schoolValue = getSchoolValue()
    }
    
    func getSchoolValue() -> String{
        ref.child("Student").child(userID!).observe(.value, with: { FIRDataSnapshot in
            self.schoolValue = (FIRDataSnapshot).childSnapshot(forPath: "school").value as! String
            print(self.schoolValue)
        })
        return schoolValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        printData()
                print(schoolValue)
    }
    
    func printData(){
        print("here")
    /*    print(schoolValue)
        ref.child(schoolValue).child(subjectValue).observe(.value, with: {FIRDataSnapshot in
            
        })*/
    }
}
