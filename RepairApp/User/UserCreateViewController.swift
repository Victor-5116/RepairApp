//
//  UserCreateViewController.swift
//  RepairApp
//
//  Created by Victor on 1/4/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

struct ServiceCreation: Decodable {
    let status: Int
    let message: String
}

class UserCreateViewController: UIViewController {

    @IBOutlet weak var txtServiceName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtServiceMenId: UITextField!
    @IBOutlet weak var txtServiceLocation: UITextField!
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var txtDeviceId: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        createServiceStatus(serviceName: txtServiceName.text!, category: txtCategory.text!, date: txtDate.text!, time: txtTime.text!, status: txtStatus.text!, serviceMenId: txtServiceMenId.text!, serviceLocation: txtServiceLocation.text!, userId: txtUserId.text!, deviceId: txtDeviceId.text!) { (result) in
            
            //self.statusResult = result
            
            if result.status == 200 {
                print("Status update successful\(result.status)")
            } else{
                print("Pls Try again\(result.status)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createServiceStatus(serviceName: String, category: String, date: String, time: String, status: String, serviceMenId: String, serviceLocation: String, userId: String, deviceId: String, completion: @escaping((ServiceCreation) -> Void)) {
        
        let httpBody = ["name": serviceName, "category": category, "date": date, "time": time, "status": status, "service_men_id": serviceMenId, "service_location": serviceLocation, "user_id": userId, "device_id": deviceId]
        
        let httpBodyJson = try! JSONSerialization.data(withJSONObject: httpBody, options: [])
        
        guard let url = URL(string: "http://3.0.10.249:3001/addService") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBodyJson
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {
                return
            }
            do {
                let status = try JSONDecoder().decode(ServiceCreation.self, from: data)
                print("Status \(status.status)")
                DispatchQueue.main.async {
                    completion(status)
                }
            } catch {
                print("Error getting Json \(error)")
            }
            }.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
