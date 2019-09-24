//
//  AlarmListTableViewController.swift
//  myAlarm
//
//  Created by Christopher Alegre on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.myAlarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell
        let alarm = AlarmController.shared.myAlarms[indexPath.row]
        cell?.alarm = alarm
        
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.myAlarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showAlarm" {
        guard let destinationVC = segue.destination as? AlarmDetailTableViewController,
            let indexPath = tableView.indexPathForSelectedRow else {return}
        
        let alarm = AlarmController.shared.myAlarms[indexPath.row]
            destinationVC.alarm = alarm
        }
    }
}

extension AlarmListTableViewController: AlarmTableViewCellDelegate {
    func alarmValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.alarm else {return}
        alarm.enabled = selected
        AlarmController.shared.toggleEnable(alarm: alarm)
        cell.updateView()
    }
}
