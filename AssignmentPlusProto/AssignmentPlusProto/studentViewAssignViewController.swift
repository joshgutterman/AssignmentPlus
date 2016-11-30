//
//  studentViewAssignViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/29/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class studentViewAssignViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    var items: [AssignmentItem] = []
    var passedValueCourse:String = ""
    var passedValueCourseUID:String = ""
    var schoolValue:String = ""
    var subjectValue:String = ""
    var courseValue:String = ""
    var courseUID:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentHomeViewController = storyBoard.instantiateViewController(withIdentifier: "studentHome") as! studentHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        courseValue = passedValueCourse
        courseUID = passedValueCourseUID
        
        let testA = getSchoolValue()
        let testB = getSubjectValue()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSchoolValue() -> String{
        ref.child("Student").child(userID!).observe(.value, with: {FIRDataSnapshot in
            self.schoolValue = (FIRDataSnapshot).childSnapshot(forPath:"school").value as! String
            print(self.schoolValue)
        })
        print("Step 3 " + "Here before print statements")
        print(passedValueCourseUID)
        return schoolValue
    }
    
    func getSubjectValue() -> String{
        ref.child("Student").child(userID!).child("courses").child(passedValueCourseUID).observe(.value, with: {FIRDataSnapshot in
            self.subjectValue = (FIRDataSnapshot).childSnapshot(forPath:"subject").value as! String
            print(self.subjectValue)
        })
        print("Step 4 " + "Here beforePrint statements")
        return subjectValue
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getTest()
    }
    
    public func getTest(){
        ref.child(schoolValue).child(subjectValue).child(courseUID).child("assignments").observe(.value, with: { FIRDataSnapshot in
            var newItems: [AssignmentItem] = []
            for item in FIRDataSnapshot.children{
                let assignmentItems = AssignmentItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(assignmentItems)
            }
            self.items = newItems
            print("*****")
            print(self.items)
            print("****")
            self.tableView.reloadData()
        })
    }
    
    //number of rows to dsiplay in tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    //what to display in rows of table view
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("Here")
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentAssignmentCell", for: indexPath)
        let assignmentItems = items[indexPath.row]
        cell.textLabel?.text = assignmentItems.assignment
        cell.detailTextLabel?.text = assignmentItems.due_date
        print("Here")
        print(cell)
        return cell
    }
    
/*    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let controller = segue.destination as! addAssignViewController
        controller.UID = passedValueCourseUID
        controller.courseValue = passedValueCourse
    }*/
    
}
