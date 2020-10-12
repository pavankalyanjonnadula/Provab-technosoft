//
//  DataStore.swift
//  ProvabAssignmentTask
//
//  Created by Pavan Kalyan Jonnadula on 17/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import Foundation

class DataStore {
    
    let typeOfCell : CellTypes?
    var answers : [Any]?
    
    init(typeOfCell : CellTypes , answers : [Any]) {
        self.answers = answers
        self.typeOfCell = typeOfCell
    }
    
//    convenience init(dict : NSDictionary) {
//        let typesOfCell = dict.object(forKey: "typeOfCell") as? CellTypes ?? CellTypes.CheckBox
//        let answers = dict.object(forKey: "answers") as? [Any] ?? []
//        self.init()
//    }
    
    
}
