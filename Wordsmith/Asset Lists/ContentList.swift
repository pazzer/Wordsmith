
//
//  ContentList.swift
// Wordsmith
//
//  Created by Paul Patterson on 20/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

protocol WordsmithModel: PersistentModel {
    static var defaultSortDescriptors: [SortDescriptor<Self>] { get }
}

struct ContentList<Model: PersistentModel & UUIDAble & StringIdentifiable & WordsmithModel, ModelView: View>: View {
    
    
    @State private var newItemSheetPresented = false
    
    @Query(sort: Model.defaultSortDescriptors)
    var content: [Model]
    
    @Binding var selection: Model?
    
    @Environment(\.modelContext) private var context
    
    @ViewBuilder var modelViewBuilder: (Model) -> ModelView
    
    var newItemValidator: (String) -> Bool
    
    var addItem: ((String, ModelContext) -> Void)?
        
    var body: some View {
        VStack(spacing: 0) {
            List(selection: $selection) {
                ForEach(content, id: \.uuid) { item in
                    modelViewBuilder(item)
                        .tag(item)
                        .swipeActions {
                            Button(role: .destructive) {
                                context.delete(item)
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
                    newItemSheetPresented.toggle()
                }, label: {
                    Label("Add \(String(describing: Model.self))", systemImage: "plus")
                })
                .padding(.leading, 16)
                .padding(.vertical, 12)
                .buttonStyle(.plain)
                Spacer()
                    
            }
            .background(.quinary)
        }
        .sheet(isPresented: $newItemSheetPresented, content: {
            NewItemSheet(isPresented: $newItemSheetPresented, selectedItem: $selection, canAdd: newItemValidator, addItem: addItem)
            .frame(width: 300, height: 300)
        })
    }
    
}



