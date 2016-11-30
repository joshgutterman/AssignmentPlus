//
//  teacherSignUpViewController.swift
//  AssignmentPlusProto
//
//  Created by Kyle Fong on 11/17/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseInstanceID

class teacherSignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var teacherFirstName: UITextField!
    @IBOutlet weak var teacherLastName: UITextField!
    @IBOutlet weak var teacherEmail: UITextField!
    @IBOutlet weak var teacherPassword: UITextField!
    @IBOutlet weak var teacherSchool: UITextField!
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.teacherFirstName.delegate = self
        self.teacherLastName.delegate = self
        self.teacherEmail.delegate = self
        self.teacherPassword.delegate = self
        self.teacherSchool.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Calls two functions
    //Check if input text contains no errors
    //Authenticate user -> teacher
    //Insert teacher's information into database
    //Redirect to the login page after running both functions
    @IBAction func signUpButton(_ sender: Any) {
        checkForTextFieldErrors(teacherFirstName: teacherFirstName, teacherLastName: teacherLastName, teacherEmail: teacherEmail, teacherPassword: teacherPassword, teacherSchool: teacherSchool);
        createTeacher(teacherFirstName: teacherFirstName, teacherLastName: teacherLastName, teacherEmail: teacherEmail, teacherPassword: teacherPassword, teacherSchool: teacherSchool);
    }
    
    //Checks the teacherSignUpView's text fields for errors
    func checkForTextFieldErrors(teacherFirstName: UITextField, teacherLastName: UITextField, teacherEmail: UITextField, teacherPassword: UITextField, teacherSchool: UITextField){
        let teacherFirstNameText = teacherFirstName.text;
        let teacherLastNameText = teacherLastName.text;
        let teacherEmailText = teacherEmail.text;
        let teacherPasswordText = teacherPassword.text;
        let teacherSchoolText = teacherSchool.text;
        let teacherEmailStringCheck: Character = "@";
        var teacherPasswordLengthCheck:Int
        teacherPasswordLengthCheck = 6;
        
        //Checks all text labels for null
        if(teacherFirstNameText!.isEmpty || teacherLastNameText!.isEmpty || teacherEmailText!.isEmpty || teacherPasswordText!.isEmpty || teacherSchoolText!.isEmpty){
            self.myAlert(alertMessage: "You must fill out all fields to sign up.");
        }
        
        //Checks teacher's email for a valid email format
        if(teacherEmailText?.characters.contains(teacherEmailStringCheck))!{
        }else{
            self.myAlert(alertMessage: "Please enter a valid email of the following format: yourTextHere@example.com");
        }
        
        //Checks if password length is greater than 6
        if((teacherPasswordText?.characters.count)! < teacherPasswordLengthCheck){
            self.myAlert(alertMessage: "Please enter a password with more than 6 characters");
        }
    }
    
    //Creates a user account in the database
    //Inserts the user's information to the appropriate rows
    //The database is a nested data structure, hence the child path declarations
    func createTeacher(teacherFirstName: UITextField, teacherLastName: UITextField, teacherEmail: UITextField, teacherPassword: UITextField, teacherSchool: UITextField){
        
        let teacherFirstNameText = teacherFirstName.text;
        let teacherLastNameText = teacherLastName.text;
        let teacherEmailText = teacherEmail.text;
        let teacherPasswordText = teacherPassword.text;
        let teacherSchoolText = teacherSchool.text;
        let ref = FIRDatabase.database().reference()
        
        //Create teacher with the proper authentication credentials
        FIRAuth.auth()?.createUser(withEmail: teacherEmailText!, password: teacherPasswordText!, completion: { (data, error) in
            if(error != nil){
                print(error?.localizedDescription as Any)
                if(((error?.localizedDescription)! as String) == "The email address is already in use by another account."){
                    self.myAlert(alertMessage: "The email address is already in use by another account. Please use a different email address.")
                }
                if(((error?.localizedDescription)! as String) == "The email address is badly formatted."){
                    self.myAlert(alertMessage: "The email address is badly formatted.")
                }
            }else{
                print("Teacher has been created")
                ref.child("Teacher").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["first_name": teacherFirstNameText, "last_name": teacherLastNameText, "email": teacherEmailText, "password": teacherPasswordText, "school": teacherSchoolText])
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextController: teacherLogInViewController = storyBoard.instantiateViewController(withIdentifier: "teacherLogIn") as! teacherLogInViewController
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
        teacherFirstName.resignFirstResponder()
        teacherLastName.resignFirstResponder()
        teacherEmail.resignFirstResponder()
        teacherPassword.resignFirstResponder()
        teacherSchool.resignFirstResponder()
        return(true)
    }

    //Builds the user error message
    func myAlert(alertMessage: String){
        let alert = UIAlertController(title: "Hi", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
