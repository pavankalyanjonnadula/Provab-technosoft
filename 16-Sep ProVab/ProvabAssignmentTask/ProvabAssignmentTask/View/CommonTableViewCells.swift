//
//  CommonTableViewCells.swift
//  ProvabAssignmentTask
//
//  Created by Pavan Kalyan Jonnadula on 17/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import Foundation
import UIKit

class CheckBoxCell : UITableViewCell{
    @IBOutlet weak var checkBtn2: UIButton!
    @IBOutlet weak var checkBtn1: UIButton!
    @IBOutlet weak var checkBtn3: UIButton!
    @IBOutlet weak var questionNumber: UILabel!

}

class RadioCell: UITableViewCell {
    @IBOutlet weak var radioBtn3: UIButton!
    @IBOutlet weak var radioBtn2: UIButton!
    @IBOutlet weak var radioBtn1: UIButton!
    @IBOutlet weak var questionNumber: UILabel!

}

class TextCell: UITableViewCell {
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var questionNumber: UILabel!
}
