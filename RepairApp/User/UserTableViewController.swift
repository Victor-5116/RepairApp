//
//  UserTableViewController.swift
//  RepairApp
//
//  Created by Victor on 27/3/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    var token = ""
    var userId = -1
    var serviceArray = [Service]()
    var service:Service!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getServicesByUser(userId: userId) { (result) in
            self.serviceArray = result.data
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        service = nil
        performSegue(withIdentifier: "segueUserToDetails", sender: self)
    }
    
    func getServicesByUser(userId:Int, completion: @escaping((ReturnedJsonData) -> Void)) {
        
        let httpHeader = ["user_id": String(userId), "Authorization": "Bear \(token)"]
        guard let url = URL(string: "http://3.0.10.249:3001/getServicesByUser") else {
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
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serviceArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let service = serviceArray[indexPath.row]
        cell.textLabel?.text = service.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.service = serviceArray[indexPath.row]
        performSegue(withIdentifier: "segueUserToDetails", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! UserCreateViewController
        vc.service = self.service
        vc.token = self.token
    }

}
