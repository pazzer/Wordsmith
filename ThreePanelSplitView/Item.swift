//
//  Item.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 06/08/2024.
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
