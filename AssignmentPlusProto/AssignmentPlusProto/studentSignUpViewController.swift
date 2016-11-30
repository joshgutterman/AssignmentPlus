//
//  studentSignUpViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/14/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class studentSignUpViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var studentFirstName: UITextField!
    
    @IBOutlet weak var studentLastName: UITextField!
    
    @IBOutlet weak var studentEmail: UITextField!
    
    @IBOutlet weak var studentPassword: UITextField!
    
    @IBOutlet weak var studentSchool: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.studentFirstName.delegate = self
        self.studentLastName.delegate = self
        self.studentEmail.delegate = self
        self.studentPassword.delegate = self
        self.studentSchool.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        checkForTextFieldErrors(studentFirstName: studentFirstName, studentLastName: studentLastName, studentEmail: studentEmail, studentPassword: studentPassword, studentSchool: studentSchool)
    }
    
    func checkForTextFieldErrors(studentFirstName: UITextField, studentLastName: UITextField, studentEmail: UITextField, studentPassword: UITextField, studentSchool: UITextField){
        let studentFirstNameText = studentFirstName.text;
        let studentLastNameText = studentLastName.text;
        let studentEmailText = studentEmail.text;
        let studentPasswordText = studentPassword.text;
        let studentSchoolText = studentSchool.text;
        let studentEmailStringCheck: Character = "@";
        var studentPasswordLengthCheck:Int
            studentPasswordLengthCheck = 6;
        
        //Checks all text labels for null
        if(studentFirstNameText!.isEmpty || studentLastNameText!.isEmpty || studentEmailText!.isEmpty || studentPasswordText!.isEmpty || studentSchoolText!.isEmpty){
            self.myAlert(alertMessage:"You must fill out all fields to sign up.");
            return
        }
        
        //Checks student email for a valid email format
        if(studentEmailText?.characters.contains(studentEmailStringCheck))!{
        }else{
            self.myAlert(alertMessage: "Please enter a valid email of the following format: yourTextHere@example.com");
        }
        
        //Checks if password length is greater than 6
        if((studPassword?.characters.count)! < studPasswordLengthCheck){
            self.myAlert(alertMessage: "Please enter a password with more than 6 characters");
        }
    }
        //Create student with the proper authentication credentials
        FIRAuth.auth()?.createUser(withEmail: studEmail!, password: studPassword!, completion: { (user, error) in
            if (error != nil){
                print(error?.localizedDescription as Any)
                self.myAlert(alertMessage:" " + (error?.localizedDescription)! as String)
            }else{
                print("Student has been created")
            }
        })
        
    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard with user hits "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        studFirstText.resignFirstResponder()
        studLastText.resignFirstResponder()
        studEmailText.resignFirstResponder()
        studPasswordText.resignFirstResponder()
        studSchoolText.resignFirstResponder()
        return(true)
    }
    
    //alert message function
    func myAlert(alertMessage: String){
        let alert = UIAlertController(title: "Hey there", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
