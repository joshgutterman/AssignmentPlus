    //
//  teacherHomeViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/19/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class teacherHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currentDate:String = ""
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    var items: [CoursesItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theDate: UILabel!
    
    //Button action to sign out
    @IBAction func logout(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil{
            do {
                try FIRAuth.auth()?.signOut()
                print("Teacher has logged out")
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "studentOrTeacherView")
                present(viewController, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
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
    
    //Gets courses using the teacherCourse struct and is passed to an array = items
    func getCourses(){
        ref.child("Teacher").child(userID!).child("courses").observe(.value, with: {FIRDataSnapshot in
            var newItems: [CoursesItem] = []
            for item in FIRDataSnapshot.children{
                let coursesItem = CoursesItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(coursesItem)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell", for: indexPath)
        let coursesItem = items[indexPath.row]
        cell.textLabel?.text = coursesItem.course
        cell.detailTextLabel?.text = coursesItem.uid

        print(cell)
        return cell
    }
        
    //go to assignments page when a class is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Teacher has selected a course")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        //instantiate the studentViewAssignViewController with two passed values
        //The course and courseUID pressed
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherAssignViewController = storyBoard.instantiateViewController(withIdentifier: "teacherAssign") as! teacherAssignViewController
        nextController.passedValueCourse = (currentCell?.textLabel?.text)!
        nextController.passedValueCourseUID = (currentCell?.detailTextLabel?.text)!
        self.present(nextController, animated:true, completion:nil)
    }    
}
