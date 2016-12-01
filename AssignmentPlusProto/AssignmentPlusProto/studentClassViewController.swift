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

class studentClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var items: [StudentCoursesPickerItem] = []
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    var subjectValue:String = ""
    var schoolValue:String = ""
    
    //Button action to instantiate the studentSubjectViewController and View
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentSubjectViewController = storyBoard.instantiateViewController(withIdentifier: "studentSubject") as! studentSubjectViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSchoolValue()
    }
    
    //Adds an async event listener on our database reference
    //When viewDidLoad is completed, the queried value is returned to the schoolValue
    func getSchoolValue(){
        ref.child("Student").child(userID!).observe(.value, with: { FIRDataSnapshot in
            self.schoolValue = (FIRDataSnapshot).childSnapshot(forPath: "school").value as! String
            print(self.schoolValue)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //In the iOS ViewController lifecycle, viewDidAppear executes after viewDidLoad, this is essential for our getAssignments() function
    override func viewDidAppear(_ animated: Bool) {
        getCourses()
    }
    
    //Gets courses using the studentCourses struct and is passed to an array = items
    func getCourses(){
        print(schoolValue)
        ref.child(schoolValue).child(subjectValue).observe(.value, with: {FIRDataSnapshot in
            var newItems: [StudentCoursesPickerItem] = []
            for item in FIRDataSnapshot.children{
                let studentCoursesPickerItem = StudentCoursesPickerItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(studentCoursesPickerItem)
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
    
    //what to display in rows of table view
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursesPickerCell", for: indexPath)
        let studentCoursesPickerItem = items[indexPath.row]
        cell.textLabel?.text = studentCoursesPickerItem.course
        cell.detailTextLabel?.text = studentCoursesPickerItem.uid
        print(cell)
        return cell
    }
    
    //go to assignments page when a class is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Student has selected a course")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        insertCourseToStudentTable(currentCell: currentCell!)
        
        //instantiate the studentHomeViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentHomeViewController = storyBoard.instantiateViewController(withIdentifier: "studentHome") as! studentHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    //This function inserts the students course to the students table
    //We make a reference to the student's table using a path of child nodes
    func insertCourseToStudentTable(currentCell: UITableViewCell){
        let className = (currentCell.textLabel?.text)!
        let UID = (currentCell.detailTextLabel?.text)!
        ref.child("Student").child(userID!).child("courses").child(UID).updateChildValues(["course": className, "subject": subjectValue, "uid": UID])
    }
    
}
