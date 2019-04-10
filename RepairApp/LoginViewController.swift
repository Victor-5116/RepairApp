//
//  ViewController.swift
//  RepairApp
//
//  Created by Victor on 25/2/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

struct Login: Decodable {
    let status: Int
    let message: String
    let token: String
    let id: Int
}
class LoginViewController: UIViewController {

    var result:Login!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        
        getLoginStatus(email: txtEmail.text!, password: txtPassword.text!) { (result) in
            self.result = result
            if result.status == 200 {
                self.performSegue(withIdentifier: "segueLoginToService", sender: self)
            } else{
                self.lblErrorMessage.text = "Login Fail! Please try again."
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nagVC = segue.destination as? UINavigationController
        let serviceVC = nagVC?.viewControllers.first as! ServiceTableViewController
        serviceVC.serviceMenId = result.id
        serviceVC.token = result.token
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getLoginStatus(email: String, password: String, completion: @escaping((Login) -> Void)) {
        
        let loginInput = ["email": email, "password": password]
        let loginInputData = try! JSONSerialization.data(withJSONObject: loginInput, options: [])
        
        guard let url = URL(string: "http://3.0.10.249:3001/loginServiceMen") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = loginInputData
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {
                return
            }
            do {
                let login = try JSONDecoder().decode(Login.self, from: data)
                print("login \(login.status)")
                DispatchQueue.main.async {
                    completion(login)
                }
            } catch {
                print("Error getting Json \(error)")
            }
        }.resume()
    }

}

