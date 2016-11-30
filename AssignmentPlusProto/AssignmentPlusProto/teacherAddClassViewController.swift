//
//  teacherAddClassViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/21/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class teacherAddClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var subjectPicker: UIPickerView!
    @IBOutlet weak var periodText: UITextField!
    @IBOutlet weak var classNameText: UITextField!
    @IBOutlet weak var termText: UITextField!
    var selectedSubject:String = ""
    let userID = FIRAuth.auth()?.currentUser?.uid
    let ref = FIRDatabase.database().reference()
    var schoolValue:String = ""
    var emailValue:String = ""
    var addClassFlag = false
    var lastName:String = ""
    
    
    //data for picker view
    var subjectArray = ["", "Science", "Math", "Literature", "History", "Art", "Government", "Language", "Music"];
    
    @IBAction func closeButton(_ sender: Any){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherHomeViewController = storyBoard.instantiateViewController(withIdentifier: "teacherHome") as! teacherHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.periodText.delegate = self
        self.classNameText.delegate = self
        self.termText.delegate = self
        
        //numberpad for period tect field
        periodText.keyboardType = UIKeyboardType.numberPad
        
        //Input data into the picker view array
        subjectPicker.delegate = self
        subjectPicker.dataSource = self
        
        //Listens on the school node of current UID on the Teacher table
        //When the 'add class' button is pressed, the value of the teacher's school is added
        ref.child("Teacher").child(userID!).observe(.value, with: { FIRDataSnapshot in
            self.schoolValue = (FIRDataSnapshot).childSnapshot(forPath: "school").value as! String
            self.emailValue = (FIRDataSnapshot).childSnapshot(forPath: "email").value as! String
            self.lastName = (FIRDataSnapshot).childSnapshot(forPath: "last_name").value as! String
        })
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
        periodText.resignFirstResponder()
        classNameText.resignFirstResponder()
        termText.resignFirstResponder()
        return(true)
    }
    
    //insert subject data into each title of picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectArray[row]
    }
    
    //number of rows in subject picker based off of array components
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectArray.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //retreive data from subject picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedSubjectInitializer = subjectArray[row]
        selectedSubject = selectedSubjectInitializer
    }
    
    //This button action instantiates a checkError method
    //If input is okay, a flag is set to true and returned, then
    //addClass method is called
    @IBAction func addClassButton(_ sender: Any) {
        print(selectedSubject)
        checkForTextFieldErrors(periodText: periodText, classNameText: classNameText, termText: termText, selectedSubject: selectedSubject)
        if(addClassFlag == true){
            addClass(periodText: periodText, classNameText: classNameText, termText: termText)}
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherHomeViewController = storyBoard.instantiateViewController(withIdentifier: "teacherHome") as! teacherHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    //Checks user input for errors
    func checkForTextFieldErrors(periodText: UITextField, classNameText: UITextField, termText: UITextField, selectedSubject: String){
        let classPeriod = periodText.text
        let className = classNameText.text
        let classTerm = termText.text
        var checkOneFlag = false
        var checkTwoFlag = false
        if(classPeriod!.isEmpty || className!.isEmpty || classTerm!.isEmpty){
            myAlert(alertMessage: "Please fill out all fields to add a class")
        }else if(selectedSubject.isEmpty){
            myAlert(alertMessage: "Please select a subject for your class")
        }else{
            checkOneFlag = true
        }
        
        if(classPeriod == " "){
            myAlert(alertMessage: "Please specify your class's period or specify if your class is an after-school program with this string " + "After School")
        }else if(classPeriod == "After School"){
            checkTwoFlag = true
        }else{
            checkTwoFlag = true
        }
        
        if(checkOneFlag == true && checkTwoFlag == true){
            addClassFlag = true
        }
    }
    
    //This method builds a string adds a class to the teacher table and school's class table
    func addClass(periodText: UITextField, classNameText: UITextField, termText: UITextField){
        let classPeriod = periodText.text
        let className = classNameText.text
        let classTerm = termText.text

        //"jwgutter1precalcwinter2017"
        let newClassPeriod = classPeriod?.replacingOccurrences(of: " ", with: "")
        let newClassName = className?.replacingOccurrences(of: " ", with: "")
        let newClassTerm = classTerm?.replacingOccurrences(of: " ", with: "")
        let UID = lastName+newClassPeriod!+newClassTerm!+newClassName!
        print(UID)
        
        ref.child("Teacher").child(userID!).child("courses").child(UID).updateChildValues(["course": className!, "period": classPeriod!, "subject": selectedSubject, "school_term": classTerm!, "uid": UID])//"UID":])
        ref.child(schoolValue).child(selectedSubject).child(UID).updateChildValues(["added_by": emailValue, "course": className!, "period": classPeriod!, "school_term": classTerm!, "uid": UID])//"UID": uidValue!]
    }
    
    func myAlert(alertMessage: String){
        let alert = UIAlertController(title: "Hi", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated:true, completion:nil)
        
    }
}


