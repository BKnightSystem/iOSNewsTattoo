//
//  LoginViewController.swift
//  NewsTattoo
//
//  Created by gigigo on 06/06/16.
//  Copyright © 2016 BKSystem. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: Visual elements
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnInitSesion: UIButton!
    @IBOutlet weak var lblCreateAccount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions Buttons
    @IBAction func btnInitSession(sender: UIButton) {
        validateFields()
    }
}

extension LoginViewController {
    func validateFields() {
        if txfEmail.text != "" && txfPassword.text != "" {
            if Utilidades.isValidEmail(txfEmail.text!) {
                print("Request Web Services for Login")
            }else {
                print("The fields are not valid")
            }
        }else {
            print("Error: The values can not be empty")
        }
    }
}
