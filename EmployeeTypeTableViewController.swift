//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Andrew Higbee on 10/23/23.
//

import UIKit

class EmployeeTypeTableViewController: UITableViewController {
    
    weak var employeeTypeDelegate: EmployeeTypeTableViewControllerDelegate?
    
    var employeeType: EmployeeType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmployeeType.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeType", for: indexPath)

        let type = EmployeeType.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = type.description
        cell.contentConfiguration = content
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         tableView.deselectRow(at: indexPath, animated: true)
         let roomType = RoomType.all[indexPath.row]
         self.roomType = roomType
         delegate?.selectRoomTypeTableViewController(self, didSelect: roomType)
         tableView.reloadData()
         */
        tableView.deselectRow(at: indexPath, animated: true)
        let employeeType = EmployeeType.allCases[indexPath.row]
        self.employeeType = employeeType
        employeeTypeDelegate?.selectEmployeeTypeTableViewController(self, didSelect: employeeType)
        tableView.reloadData()
    }
}

protocol EmployeeTypeTableViewControllerDelegate: AnyObject {
    func selectEmployeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType)
}
