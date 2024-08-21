//
//  SourceList.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 20/08/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct SourcesList: View {
    
    @State private var newSourceSheetPresented = false
    
    @Query(sort: \Source.name, order: .forward)
    var sources: [Source]
    
    @Binding var selectedSource: Source?
    @Environment(\.modelContext) private var context

        
    var body: some View {
        VStack(spacing: 0) {
            List(selection: $selectedSource) {
                ForEach(sources, id: \.uuid) { source in
                    SourceRow(source: source)
                        .tag(source)
                        .swipeActions {
                            Button(role: .destructive) {
                                context.delete(source)
                                try? context.save()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            
            
            Divider()
                
            HStack {
                Button(action: {
                    newSourceSheetPresented.toggle()
                    
                }, label: {
                    Label("Add Source", systemImage: "plus")
                })
                .padding(.leading, 16)
                .padding(.vertical, 12)
                .buttonStyle(.plain)
                Spacer()
                    
            }
            .background(.quinary)
        }
        .background(.white)
        .sheet(isPresented: $newSourceSheetPresented, content: {
            NewSourceSheet(isPresented: $newSourceSheetPresented, selectedSource: $selectedSource)
                .frame(width: 300, height: 300)
        })
        .navigationTitle("Words")
    }
}


