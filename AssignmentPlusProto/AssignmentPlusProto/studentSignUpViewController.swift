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
import FirebaseDatabase
import FirebaseInstanceID

class studentSignUpViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var studentFirstName: UITextField!
    @IBOutlet weak var studentLastName: UITextField!
    @IBOutlet weak var studentEmail: UITextField!
    @IBOutlet weak var studentPassword: UITextField!
    @IBOutlet weak var studentSchool: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.studentFirstName.delegate = self
        self.studentLastName.delegate = self
        self.studentEmail.delegate = self
        self.studentPassword.delegate = self
        self.studentSchool.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Calls two functions
    //Check if input text contains no errors
    //Authenticate user -> student
    //Insert student's information into database
        //Redirect to the login page after running both functions
    @IBAction func signUpButton(_ sender: Any) {
        checkForTextFieldErrors(studentFirstName: studentFirstName, studentLastName: studentLastName, studentEmail: studentEmail, studentPassword: studentPassword, studentSchool: studentSchool)
        createStudent(studentFirstName: studentFirstName, studentLastName: studentLastName, studentEmail: studentEmail, studentPassword: studentPassword, studentSchool: studentSchool)
    }
    
    //Checks the studentSignUpView's text fields for errors
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
        if((studentPasswordText?.characters.count)! < studentPasswordLengthCheck){
            self.myAlert(alertMessage: "Please enter a password with more than 6 characters");
        }
    }
    
    //Creates a user account in the database
    //Inserts the user's information to the appropriate rows
    //The database is a nested data structure, hence the child path declarations
    func createStudent(studentFirstName: UITextField, studentLastName: UITextField, studentEmail: UITextField, studentPassword: UITextField, studentSchool: UITextField){
        let studentFirstNameText = studentFirstName.text;
        let studentLastNameText = studentLastName.text;
        let studentEmailText = studentEmail.text;
        let studentPasswordText = studentPassword.text;
        let studentSchoolText = studentSchool.text;
        let ref = FIRDatabase.database().reference()
        //Create student with the proper authentication credentials
        FIRAuth.auth()?.createUser(withEmail: studentEmailText!, password: studentPasswordText!, completion: { (data, error) in
            if(error != nil){
                print(error?.localizedDescription as Any)
                if(((error?.localizedDescription)! as String) == "The email address is already in use by another account."){
                    self.myAlert(alertMessage: "The email address is already in use by another account. Please use a different email address.")
                }
                if(((error?.localizedDescription)! as String) == "The email address is badly formatted."){
                    self.myAlert(alertMessage: "The email address is badly formatted.")
                }
            }else{
                print("Student has been created")
                ref.child("Student").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["first_name":studentFirstNameText, "last_name": studentLastNameText, "email": studentEmailText, "password": studentPasswordText, "school": studentSchoolText])
            
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextController: studentLogInViewController = storyBoard.instantiateViewController(withIdentifier: "studentLogInViewController") as! studentLogInViewController
                self.present(nextController, animated:true, completion:nil)
            }
        })
    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard with user hits "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        studentFirstName.resignFirstResponder()
        studentLastName.resignFirstResponder()
        studentEmail.resignFirstResponder()
        studentPassword.resignFirstResponder()
        studentSchool.resignFirstResponder()
        return(true)
    }
    
    //Builds the user error message
    func myAlert(alertMessage: String){
        let alert = UIAlertController(title: "Hey There", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
