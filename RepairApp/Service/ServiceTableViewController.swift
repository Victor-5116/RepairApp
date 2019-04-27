//
//  ServiceTableViewController.swift
//  RepairApp
//
//  Created by Victor on 26/2/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

struct ReturnedJsonData: Decodable {
    let status: Int
    let message: String
    let data: [Service]
}

struct Service: Decodable {
    let id: Int
    let name: String
    let category: Int
    let date: String
    let time: String
    let queue_no: String
    let status: String
    let service_men_id: Int
    let service_location: String
    let user_id: Int
    let device_id: Int
}

class ServiceTableViewController: UITableViewController {

    var serviceMenId = -1
    var token = ""
    var serviceArray = [Service]()
    var service:Service!

    @IBAction func btnLogoutPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        getServicesByServiceMen(serviceMenId: serviceMenId) { (result) in
            self.serviceArray = result.data
            self.tableView.reloadData()
        }
    }
    
    func getServicesByServiceMen(serviceMenId:Int, completion: @escaping((ReturnedJsonData) -> Void)) {
        
        let httpHeader = ["service_men_id": String(serviceMenId), "Authorization": "Bear \(token)"]
        guard let url = URL(string: "http://3.0.10.249:3001/getServicesByServiceMen") else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = httpHeader
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {
                return
            }
            
            do {
                let returnedJsonData = try JSONDecoder().decode(ReturnedJsonData.self, from: data)
                DispatchQueue.main.async {
                    completion(returnedJsonData)
                }
            } catch {
                print("Error decoding \(error)")
            }
        }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceMenCell", for: indexPath) as! ServiceTableViewCell
        let service = serviceArray[indexPath.row]
        cell.setServices(service: service)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.service = serviceArray[indexPath.row]
        performSegue(withIdentifier: "segueServiceMenToDetails", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ServiceDetailsViewController
        vc.service = self.service
        vc.token = self.token
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}
