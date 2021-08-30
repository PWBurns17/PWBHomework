//
//  ViewController.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSaveButtonClick(_ sender: Any) {
        
        if let str = nameTextField?.text {
            if (str.count >= 3){
                
                let vc = storyboard?.instantiateViewController(identifier: "MovieListViewController") as! MovieListViewController
                vc.name = nameTextField.text ?? ""
                present(vc, animated: true)
            }
            else{
                print("less than 3")
            }
        }
    }
}
