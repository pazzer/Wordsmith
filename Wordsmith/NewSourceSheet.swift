//
//  NewSourceSheet.swift
// Wordsmith
//
//  Created by Paul Patterson on 20/08/2024.
//

import Foundation
import SwiftData
import SwiftUI

struct NewSourceSheet: View {
    
    @State var source: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @Binding var isPresented: Bool
    
    @Binding var selectedSource: Source?
    
    @State var invalidSource = true
    
    @Query var sources: [Source]
    
    func validateSource() {
        let source = source.trimmingCharacters(in: .whitespaces).lowercased()
        invalidSource = source.isEmpty || !sources.filter({ $0.name.lowercased() == source }).isEmpty
    }
    
    var body: some View {
        
        VStack {
            Text("Enter Source")
                .font(.title)
                .onChange(of: source) {
                    self.validateSource()
                }
            TextField("", text: $source)
                .multilineTextAlignment(.center)
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                Spacer()
                
                Button("Add", role: .none) {
                    let source = Source(name: source)
                    modelContext.insert(source)
                    isPresented = false
                }
                .disabled(invalidSource)
                
            
                

            }
        }
        .onDisappear(perform: {
            DispatchQueue.main.async {
                selectedSource = Source.withName(source, in: modelContext)
            }
        })
        .padding()
        
    }
    
}




