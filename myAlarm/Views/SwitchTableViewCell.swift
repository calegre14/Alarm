//
//  SwitchTableViewCell.swift
//  myAlarm
//
//  Created by Christopher Alegre on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

protocol AlarmTableViewCellDelegate: class {
    func alarmValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}
class SwitchTableViewCell: UITableViewCell {

    var alarm: Alarm? {
        didSet {
            updateView()
        }
    }

    weak var delegate: AlarmTableViewCellDelegate?
    
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.alarmValueChanged(self, selected: alarmSwitch.isOn)
    }
    
    func updateView() {
        guard let alarm = alarm else {return}
        alarmLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
    
}//End Of Class

