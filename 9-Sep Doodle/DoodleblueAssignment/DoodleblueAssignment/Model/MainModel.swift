//
//  MainModel.swift
//  DoodleblueAssignment
//
//  Created by Pavan Kalyan Jonnadula on 10/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import Foundation

struct MainModel: Codable {
    let unorderedStatements: [UnorderedStatements]
    private enum CodingKeys: String, CodingKey {
        case unorderedStatements = "unorderedStatements"
    }
}

struct UnorderedStatements: Codable {
    
    let statement: String
    var position: Int?
}
