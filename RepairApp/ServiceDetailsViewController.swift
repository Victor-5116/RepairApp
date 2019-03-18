//
//  ServiceDetailsViewController.swift
//  RepairApp
//
//  Created by Victor on 28/2/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

struct Status: Decodable {
    let status: Int
    let message: String
}

class ServiceDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var serviceID: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceCategory: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var serviceQueue: UILabel!
    @IBOutlet weak var serviceStatusPicker: UIPickerView!
    @IBOutlet weak var serviceManID: UILabel!
    @IBOutlet weak var serviceLocation: UILabel!
    @IBOutlet weak var serviceUserID: UILabel!
    @IBOutlet weak var serviceDeviceID: UILabel!
    
    var service:Service!
    var statusResult:Status!
    
    let pickerData = ["Pending ︽","finished"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        serviceID.text = String(service.id)
        serviceName.text = service.name
        serviceCategory.text = service.category
        serviceDate.text = service.date
        serviceTime.text = service.time
        serviceQueue.text = service.queue_no
        serviceManID.text = String(service.service_men_id)
        serviceLocation.text = service.service_location
        serviceUserID.text = String(service.user_id)
        serviceDeviceID.text = String(service.device_id)
        
        serviceStatusPicker.delegate = self
        serviceStatusPicker.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(service.status == "Pending") {
            serviceStatusPicker.selectRow(0, inComponent: 0, animated: false)
        } else {
            serviceStatusPicker.selectRow(1, inComponent: 0, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        getServiceStatus(id: String(service!.id), rf_id: "orogh2i3792gwo") { (result) in
            self.statusResult = result
            if result.status == 200 {
                print("Status update successful\(result.status)")
            } else{
                print("Pls Try again\(result.status)")
            }
        }
    }
    
    func getServiceStatus(id: String, rf_id: String, completion: @escaping((Status) -> Void)) {
        
        let httpHeader = ["id": id]
        let httpBody = ["rf_id": rf_id]
        let httpBodyJson = try! JSONSerialization.data(withJSONObject: httpBody, options: [])
        
        guard let url = URL(string: "http://3.0.10.249:3001/updateServiceStatus") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBodyJson
        request.allHTTPHeaderFields = httpHeader
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {
                return
            }
            do {
                let status = try JSONDecoder().decode(Status.self, from: data)
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
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 11)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = pickerData[row]
    
        if(service.status == "Pending") {
            pickerLabel?.textColor = UIColor.orange
        } else {
            pickerView.selectRow(1, inComponent: 0, animated: false)
            pickerLabel?.textColor = UIColor.green
        }
        
        return pickerLabel!
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
