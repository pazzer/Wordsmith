//
//  GroupsList.swift
// Wordsmith
//
//  Created by Paul Patterson on 21/08/2024.
//

import SwiftData
import SwiftUI

struct GroupsList: View {
    
    @Binding var selection: Group?
    
    @Query var groups: [Group]
    
    var body: some View {
        ContentList(selection: $selection) { group in
            GroupRow(group: group)
        } newItemValidator: { candidateName in
            groups.first(where: { $0.name.lowercased() == candidateName.lowercased()}) == nil
        }
    }
}
