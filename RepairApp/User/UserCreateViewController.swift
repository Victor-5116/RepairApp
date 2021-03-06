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

class UserCreateViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var token = ""
    var service:Service!
    var categoryArray = [Category]()
    private var categoryPicker: UIPickerView?
    
    @IBOutlet weak var txtServiceName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtServiceMenId: UITextField!
    @IBOutlet weak var txtServiceLocation: UITextField!
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var txtDeviceId: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        if service != nil {
            updateServiceStatus(serviceId: String(service.id), date: txtDate.text!, time: txtTime.text!, serviceMenId: txtServiceMenId.text!) { (result) in
                
                if result.status == 200 {
                    print("Status update successful\(result.status)")
                } else{
                    print("Pls Try again\(result.status)")
                }
            }
        } else {
            createServiceStatus(serviceName: txtServiceName.text!, category: txtCategory.text!, date: txtDate.text!, time: txtTime.text!, status: txtStatus.text!, serviceMenId: txtServiceMenId.text!, serviceLocation: txtServiceLocation.text!, userId: txtUserId.text!, deviceId: txtDeviceId.text!) { (result) in
                
                //self.statusResult = result
                
                if result.status == 200 {
                    print("Status update successful\(result.status)")
                } else{
                    print("Pls Try again\(result.status)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if service != nil {
            txtServiceName.text = service.name
            txtServiceName.isEnabled = false
            txtCategory.text = String(service.category)
            txtCategory.isEnabled = false
            txtDate.text = service.date
            txtTime.text = service.time
            txtStatus.text = service.status
            txtStatus.isEnabled = false
            txtServiceMenId.text = String(service.service_men_id)
            txtServiceLocation.text = service.service_location
            txtServiceLocation.isEnabled = false
            txtUserId.text = String(service.user_id)
            txtUserId.isEnabled = false
            txtDeviceId.text = String(service.device_id)
            txtDeviceId.isEnabled = false
            btnAdd.setTitle("Update", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        categoryPicker = UIPickerView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        categoryPicker?.dataSource = self
        categoryPicker?.delegate = self
        txtCategory.inputView = categoryPicker
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func updateServiceStatus(serviceId: String, date: String, time: String, serviceMenId: String, completion: @escaping((ServiceCreation) -> Void)) {
        
        let httpHeader = ["service_id": serviceId, "Authorization": "Bear \(token)"]
        let httpBody = ["date": date, "time": time, "service_men_id": serviceMenId]
        
        let httpBodyJson = try! JSONSerialization.data(withJSONObject: httpBody, options: [])
        
        guard let url = URL(string: "http://3.0.10.249:3001/changeServiceInfo") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = httpHeader
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
    
    func createServiceStatus(serviceName: String, category: String, date: String, time: String, status: String, serviceMenId: String, serviceLocation: String, userId: String, deviceId: String, completion: @escaping((ServiceCreation) -> Void)) {
        
        let httpHeader = ["Authorization": "Bear \(token)"]
        let httpBody = ["name": serviceName, "category": category, "date": date, "time": time, "status": status, "service_men_id": serviceMenId, "service_location": serviceLocation, "user_id": userId, "device_id": deviceId]
        
        let httpBodyJson = try! JSONSerialization.data(withJSONObject: httpBody, options: [])
        
        guard let url = URL(string: "http://3.0.10.249:3001/addService") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = httpHeader
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

    // MARK: PickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let category = categoryArray[row].name
        txtCategory.text = categoryArray[row].name
        view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  
        return categoryArray[row].name
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
