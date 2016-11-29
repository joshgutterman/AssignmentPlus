//
//  addAssignViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/27/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class addAssignViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var detailsText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    var schoolValue:String = ""
    
    var addAssignFlag = false
    
    @IBAction func closeButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherAssignViewController = storyBoard.instantiateViewController(withIdentifier: "teacherAssign") as! teacherAssignViewController
        self.present(nextController, animated:true, completion:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = UIDatePickerMode.date
        
        self.titleText.delegate = self
        self.detailsText.delegate = self
        

        ref.child("Teacher").child(userID!).observe(.value, with: {
            FIRDataSnapshot in
            self.schoolValue = (FIRDataSnapshot).childSnapshot(forPath: "school").value as! String
        })
        
        //passing subject
        
       // ref.child(schoolValue).child()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard with user hits "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleText.resignFirstResponder()
        detailsText.resignFirstResponder()
        return(true)
    }

    
    @IBAction func addAssignButton(_ sender: Any) {
        
        print("Assignment Added")
        checkForTextFieldErrors(titleText: titleText, detailsText: detailsText)
        if(addAssignFlag == true){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let dateString = dateFormatter.string(from: datePicker.date)
            print(dateString)
            
        }
        
        print(self.schoolValue)
        print("********")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherAssignViewController = storyBoard.instantiateViewController(withIdentifier: "teacherAssign") as! teacherAssignViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    func checkForTextFieldErrors(titleText: UITextField, detailsText: UITextField){
        let assignTitle = titleText.text
        let assignDetails = detailsText.text
        
        if(assignTitle!.isEmpty || assignDetails!.isEmpty){
            myAlert(alertMessage: "Please fill out all fields to add an assignment")
        }else{
            addAssignFlag = true
        }
        
    }
    
    func myAlert(alertMessage: String){
        let alert = UIAlertController(title: "Hi", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated:true, completion:nil)
        
    }


}



