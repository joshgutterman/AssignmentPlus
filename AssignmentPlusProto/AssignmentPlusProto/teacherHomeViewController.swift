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
    
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    //TEMP for tableview
    //var classes = ["P4 Calculus", "P1 English", "P6 US History"]
    var items: [CoursesItem] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theDate: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theDate.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.full, timeStyle: DateFormatter.Style.none)
        
        //TEMP for tableview
        tableView.reloadData();
        
    /*  ref.child("Teacher").child(userID!).observe(.value, with: { FIRDataSnapshot in
            for course in FIRDataSnapshot.childSnapshot(forPath: "courses").children{

            }
        })*/
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTeacherInformation(){
        let information = FIRDatabase.database().reference()
        information.child("Teacher")
        
    }
    
    //number of rows to dsiplay in tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //what to display in rows of table view
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let coursesItem = items[indexPath.row]
        
        cell.textLabel?.text = coursesItem.course
        cell.detailTextLabel?.text = coursesItem.school_term

        print(cell)
        return cell
    }
    
    //go to assignments page when a class is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Teacher has selected a course")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherAssignViewController = storyBoard.instantiateViewController(withIdentifier: "teacherAssign") as! teacherAssignViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    

}
