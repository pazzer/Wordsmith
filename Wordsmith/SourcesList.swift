//
//  SourceList.swift
// Wordsmith
//
//  Created by Paul Patterson on 20/08/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct SourcesList: View {
    
    @Query(sort: \Source.name, order: .forward)
    var sources: [Source]
    
    @Binding var selection: Source?
    
    var body: some View {
        ContentList(selection: $selection) { source in
            SourceRow(source: source)
        } newItemValidator: { candidateName in
            sources.first(where: { $0.name.lowercased() == candidateName.lowercased() }) == nil
        }
    }
}


