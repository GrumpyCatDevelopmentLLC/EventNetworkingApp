//
//  RegisterViewController.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/30/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmTextField: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    var session: URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmTextField.delegate = self
        
        let config = URLSessionConfiguration.default
        session = URLSession.init(configuration: config)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let displayName = self.displayNameTextField.text!
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        let confirmedPassword = self.passwordTextField.text!
        
        let privateQueue = OperationQueue()
        privateQueue.addOperation {
            if displayName.isEmpty == false && email.isEmpty == false && password.isEmpty == false && confirmedPassword.isEmpty == false && password == confirmedPassword {
                let url = URL(string: EventNetworkingAPI.baseURL + EventNetworkingAPIMethods.CreateUser.rawValue)
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let userPayload: [String: Any] = ["email": "\(email)", "displayName": "\(displayName)", "password": "\(confirmedPassword)"]
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: userPayload, options: []) as Data
                
                let task = self.session?.dataTask(with: request) { data, response, error in
                    
                    let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                    let userData = jsonData["responseUser"] as? [String: AnyObject]
                    let error = jsonData["errorMessage"] as? String
                    
                    print(jsonData)
                    print(response)
                    
                    if userData != nil && error == nil {
                        OperationQueue.main.addOperation() {
                            let mainBundle = Bundle.main
                            let storyBoard = UIStoryboard(name: "Main", bundle: mainBundle)
                            let nav = storyBoard.instantiateViewController(withIdentifier: "MainNavController") as! UINavigationController
                            let dest = nav.viewControllers.first as! EventsViewController
                            let user = User(data: userData!)
                            dest.user = user
                            self.show(nav, sender: nil)
                        }
                    } else {
                        OperationQueue.main.addOperation() {
                            let alert = UIAlertController(title: "Invalid email or display name", message: "Your email or display name is already in use", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true) {
                                self.displayNameTextField.text = ""
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                                self.passwordConfirmTextField.text = ""
                            }
                        }
                    }
                }
                task?.resume()
            }
        }
        
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

