//
//  Item.swift
//  Journal
//
//  Created by Mélissa Kintz on 25/07/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
