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

    @IBAction func logout(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil{
            do {
                try FIRAuth.auth()?.signOut()
                print("Student has logged out")
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "studentOrTeacherView")
                present(viewController, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addClassButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentSubjectViewController = storyBoard.instantiateViewController(withIdentifier: "studentSubject") as! studentSubjectViewController
        self.present(nextController, animated:true, completion:nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theDate.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.full, timeStyle: DateFormatter.Style.none)

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //number of rows to dsiplay in tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //what to display in rows of table view
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCoursesCell", for: indexPath)
        let studentCoursesItem = items[indexPath.row]
        cell.textLabel?.text = studentCoursesItem.course
        cell.detailTextLabel?.text = studentCoursesItem.uid
        
        print(cell)
        return cell
    }
    

}
