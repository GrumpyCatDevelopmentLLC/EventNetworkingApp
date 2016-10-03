//
//  ViewController.swift
//  EventNetworkingApp
//
//  Created by Rodney Sampson on 9/29/16.
//  Copyright © 2016 GrumpyCatDevelopmentLLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    var session: URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let config = URLSessionConfiguration.default
        session = URLSession.init(configuration: config)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // add to api class
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        let privateQueue = OperationQueue()
        privateQueue.addOperation {
            if email.isEmpty == false && password.isEmpty == false {
                let url = URL(string: EventNetworkingAPI.baseURL + EventNetworkingAPIMethods.Login.rawValue)
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let userPayload = ["email":"\(email)", "password": "\(password)"]
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: userPayload, options: [])
                
                let task = self.session?.dataTask(with: request) { data, response, error in
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("\n\n\n\n\nstatusCode should be 200, but is \(httpStatus.statusCode)")
                    }
                    let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                    let userData = jsonData["responseUser"] as? [String: AnyObject]
                    
                    if userData != nil {
                        print("\n\n\n\n\n\(jsonData)")
                        print("\n\n\n\n\n\(userData)\n\n\n\n\n")
                        
                        let user = User(data: userData!)
                        if user != nil && self.passwordTextField.text == userData?["password"] as! String? {
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
                            self.loginErrorAlert()
                        }
                    } else {
                        self.loginErrorAlert()
                    }
                }
                task?.resume()
            } else {
                self.loginErrorAlert()
            }
        }
        // add to api class
    }
    
    func loginErrorAlert() {
        OperationQueue.main.addOperation() {
            let alert = UIAlertController(title: "Invalid email or password", message: "You email or password does not match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true) {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
