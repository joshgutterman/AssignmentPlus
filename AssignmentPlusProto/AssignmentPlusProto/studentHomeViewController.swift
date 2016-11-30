//
//  studentHomeViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/15/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class studentHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var theDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var items: [StudentCoursesItem] = []
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    var currentDate:String = ""

    //Button action to sign out
    @IBAction func logout(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil{
            do {
                try FIRAuth.auth()?.signOut()
                print("Student has logged out")
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "studentOrTeacherView")
                present(viewController, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)}}
    }
    
    //When pressed, the button instantiates the studentSubjectViewController
    @IBAction func addClassButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentSubjectViewController = storyBoard.instantiateViewController(withIdentifier: "studentSubject") as! studentSubjectViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    //viewDidLoad calls getDate()
    //and getCourses()
    override func viewDidLoad() {
        super.viewDidLoad()
        getDate(theDate: theDate)
        getCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Gets the current date and populates the UITextLabel in the header
    func getDate(theDate: UILabel){
        theDate.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.full, timeStyle: DateFormatter.Style.none)
        currentDate = theDate.text!
    }
    
    //Gets courses using the studentCourse struct and is passed to an array = items
    func getCourses(){
        ref.child("Student").child(userID!).child("courses").observe(.value, with: {FIRDataSnapshot in
            var newItems: [StudentCoursesItem] = []
            for item in FIRDataSnapshot.children{
                let studentCoursesItem = StudentCoursesItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(studentCoursesItem)
            }
            self.items = newItems
            self.tableView.reloadData()
        })
    }
    
    //number of rows to dsiplay in tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //This function populates table cells with item array
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCoursesCell", for: indexPath)
        let studentCoursesItem = items[indexPath.row]
        cell.textLabel?.text = studentCoursesItem.course
        cell.detailTextLabel?.text = studentCoursesItem.uid
        
        print(cell)
        return cell
    }
    
    //go to assignments page when a class is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Student has selected a course")
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        //instantiate the studentViewAssignViewController with two passed values
        //The course and courseUID pressed
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentViewAssignViewController = storyBoard.instantiateViewController(withIdentifier: "classAssign") as! studentViewAssignViewController
        nextController.passedValueCourse = (currentCell?.textLabel?.text)!
        nextController.passedValueCourseUID = (currentCell?.detailTextLabel?.text)!
        self.present(nextController, animated:true, completion:nil)
    }
}
