//
//  studentViewAssignViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/29/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

//GetAssignment() is in viewDidAppear as opposed to viewDidLoad (getSchoolValue and getSubjectValue)
//because of Firebase asynchronous calling

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
    
    //This button action instantiates the teacherHomeViewController and View
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentHomeViewController = storyBoard.instantiateViewController(withIdentifier: "studentHome") as! studentHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseValue = passedValueCourse
        courseUID = passedValueCourseUID
        getSchoolValue()
        getSubjectValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Adds an async event listener on our database reference
    //When viewDidLoad is completed, the queried value is returned to the schoolValue variable
    func getSchoolValue(){
        ref.child("Student").child(userID!).observe(.value, with: {FIRDataSnapshot in
            self.schoolValue = (FIRDataSnapshot).childSnapshot(forPath:"school").value as! String
            print(self.schoolValue)
        })
    }
    
    //Adds an async event listener on our database reference
    //When viewDidLoad is completed, the queried value is returned to the subjectValue variable
    func getSubjectValue(){
        ref.child("Student").child(userID!).child("courses").child(passedValueCourseUID).observe(.value, with: {FIRDataSnapshot in
            self.subjectValue = (FIRDataSnapshot).childSnapshot(forPath:"subject").value as! String
            print(self.subjectValue)
        })
    }
    
    //In the iOS ViewController lifecycle, viewDidAppear executes after viewDidLoad, this is essential for our getAssignments() function
    override func viewDidAppear(_ animated: Bool) {
        getStudentAssignments()
    }
    
    //Gets assignments using the studentAssignmentItem struct and is passed to an array = items
    public func getStudentAssignments(){
        ref.child(schoolValue).child(subjectValue).child(courseUID).child("assignments").observe(.value, with: { FIRDataSnapshot in
            var newItems: [AssignmentItem] = []
            for item in FIRDataSnapshot.children{
                let assignmentItems = AssignmentItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(assignmentItems)
            }
            self.items = newItems
            print(self.items)
            self.tableView.reloadData()
        })
    }
    
    //number of rows to dsiplay in tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    //Table cells are populated with the item array and displayed in the studentAssignmentCell identifier on the studentViewAssignmentView View
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("Here")
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentAssignmentCell", for: indexPath)
        let assignmentItems = items[indexPath.row]
        cell.textLabel?.text = assignmentItems.assignment
        cell.detailTextLabel?.text = assignmentItems.due_date
        print(cell)
        return cell
    }    
}
