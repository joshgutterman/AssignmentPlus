//
//  teacherAssignViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/24/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit

class teacherAssignViewController: UIViewController {

    @IBAction func backButton(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherHomeViewController = storyBoard.instantiateViewController(withIdentifier: "teacherHome") as! teacherHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    var passedValueCourse:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelCourseValue = passedValueCourse

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
