//
//  ComposeViewController.swift
//  Mailbox
//
//  Created by Go, Ian on 10/7/16.
//  Copyright © 2016 Go, Ian. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var ccTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didEditFields(_ sender: AnyObject) {
        
        if toTextField.text!.isEmpty || messageTextField.text!.isEmpty{
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
        
    }
    @IBAction func didTapSend(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
