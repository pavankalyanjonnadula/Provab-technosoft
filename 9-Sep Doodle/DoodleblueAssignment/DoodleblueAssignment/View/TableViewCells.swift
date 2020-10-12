//
//  TableViewCells.swift
//  DoodleblueAssignment
//
//  Created by Pavan Kalyan Jonnadula on 11/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import Foundation
import UIKit
class UnOrderedCells : UITableViewCell{
    @IBOutlet weak var postionSelecteddropDown: HADropDown!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statementLabel: UILabel!
}


class SequenceCells : UITableViewCell{
    @IBOutlet weak var deletaBtn: UIButton!
    @IBOutlet weak var staementLabel: UILabel!
}
