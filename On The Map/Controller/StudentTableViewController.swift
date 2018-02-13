//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by Ansuke on 2/6/18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    var studentDictionary = [StudentLocation]()
    let reuseIdentifier = "studentCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.studentDictionary = ParseClient.sharedInstance().StudentInformationArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.sharedInstance().getStudentLocations(100, skip: nil, order: nil) { (success, data, error) in
            guard error == nil else {
                print("Error getting student locations.")
                return
            }
            
            if (success) {
                
                let dictionary = data!.map({ (student: [String: AnyObject]) -> StudentLocation in
                    StudentLocation.init(dictionary: student)
                })
                print(dictionary)
                ParseClient.sharedInstance().StudentInformationArray = dictionary
                print("Succ")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentDictionary.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! StudentTableViewCell

        cell.studentNameLabel.text = "\(studentDictionary[indexPath.row].firstName ?? "") \(studentDictionary[indexPath.row].lastName ?? "")"
        cell.studentShareLabel.text = studentDictionary[indexPath.row].mediaURL

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
