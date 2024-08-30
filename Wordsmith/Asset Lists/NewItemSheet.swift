//
//  NewItemSheet.swift
// Wordsmith
//
//  Created by Paul Patterson on 21/08/2024.
//

import SwiftUI
import SwiftData

struct NewItemSheet<Model: PersistentModel & UUIDAble & StringIdentifiable>: View {
    
    @State var candidateValue: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @Binding var isPresented: Bool
    
    @Binding var selectedItem: Model?
    
    @State var invalidCandidateValue = true
    
    @Query var sources: [Model]
    
    var canAdd: (String) -> Bool
    
    func validateSource() {
        let candidateValue = candidateValue.trimmingCharacters(in: .whitespaces).lowercased()
        invalidCandidateValue = candidateValue.isEmpty || !canAdd(candidateValue)
    }
    
    var addItem: ((String, ModelContext) -> Void)?
    
    var body: some View {
        
        VStack {
            Text("Enter \(String(describing: Model.self))")
                .font(.title)
                .onChange(of: candidateValue) {
                    self.validateSource()
                }
            TextField("", text: $candidateValue)
                .multilineTextAlignment(.center)
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                Spacer()
                
                Button("Add", role: .none) {
                    if let addItem = self.addItem {
                        addItem(candidateValue, modelContext)
                    } else {
                        let item = Model.create(from: candidateValue, in: modelContext)
                        modelContext.insert(item)
                    }
                    isPresented = false
                    
                }
                .disabled(invalidCandidateValue)
            }
        }
        .onDisappear(perform: {
            DispatchQueue.main.async {
                selectedItem = Model.fetch(from: candidateValue, in: modelContext)
            }
        })
        .padding()
        
    }
    
}


