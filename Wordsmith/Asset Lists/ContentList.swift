
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


struct WordsView<RowView: View>: View {
    
    @Query
    var words: [Word]
    
    let rowView: (Word) -> RowView
    
    @Binding var selection: Word?
    
    init(selection: Binding<Word?>, searchString: String, restrictToRecents: Bool, @ViewBuilder rowView: @escaping (Word) -> RowView) {
        self.rowView = rowView
        self._selection = selection
        let cutoff = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -3, to: .now)!
        _words = Query(filter: #Predicate {
            if restrictToRecents {
                if searchString.isEmpty {
                    return $0.created >= cutoff
                } else {
                    return $0.created >= cutoff && $0.word.contains(searchString)
                }
            } else {
                return searchString.isEmpty ? true : $0.word.contains(searchString)
            }
        }, sort: Word.defaultSortDescriptors)
    }
    
    var body: some View {
        
        List(words, selection: $selection) { word in
            rowView(word)
                .tag(word)
        }
    }
}


struct SearchField: View {
    
    @Binding var searchString: String
    @Binding var restrictToRecents: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(.filterBarStroke)
            .fill(.filterBarBackground)
            .overlay {
                HStack {
                    TextField("Search Words", text: $searchString, prompt: Text("Filter"))
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 8)
                        .font(.caption)
                    Spacer()
                    HStack {
                        if !searchString.isEmpty {
                            Button(action: {
                                searchString = ""
                            }) {
                                Label("Clear", systemImage: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                                    
                            }
                            .controlSize(.small)
                        }
                        Button(action: {
                            restrictToRecents.toggle()
                        }) {
                            Label("Recents", systemImage: restrictToRecents ? "clock.fill" : "clock")
                                .foregroundStyle(restrictToRecents ? Color.accentColor : Color.secondary)
                        }
                    }
                    .padding(.trailing, 8)
                }
                
            }
            .frame(maxHeight: 24)
            .buttonStyle(PlainButtonStyle())
            .labelStyle(IconOnlyLabelStyle())
    }
}






/**
 This extension on View is optional, but makes calling your view modifier a little easier.
 */



struct SearchableWords<RowView: View>: View {
    
    @Environment(\.modelContext) private var context
    
    @State var searchString = String()
    
    @State var restrictToRecents = false
    
    @State private var addingNewWord = false
    
    @Binding var selection: Word?
    
    var rowView: (Word) -> RowView
    
    var includeAddOption = false
    
    var body: some View {
        VStack(spacing: 0) {
            WordsView(selection: $selection, searchString: searchString, restrictToRecents: restrictToRecents, rowView: rowView)
            HStack {
                if includeAddOption {
                    Button("Add Item", systemImage: "plus", action: { addingNewWord.toggle() })
                        .buttonStyle(PlainButtonStyle())
                        .labelStyle(.iconOnly)
                }
                SearchField(searchString: $searchString, restrictToRecents: $restrictToRecents)
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 6)
        }

        
        .sheet(isPresented: $addingNewWord, content: {
            NewItemSheet(isPresented: $addingNewWord, selectedItem: $selection, canAdd: { string in
                !Word.alreadyExists(string: string, in: context)
            }, addItem: { string, context in
                _ = Word.new(word: string, in: context)
            })
            .frame(width: 300, height: 300)
        })
        .background(.clear)
    }
}
