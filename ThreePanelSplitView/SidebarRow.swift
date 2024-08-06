//
//  WordRow.swift
//  ThreePanelSplitView
//
//  Created by Paul Patterson on 06/08/2024.
//

import Foundation
import SwiftUI

struct SidebarRow: View {
    
    var item: Sidebar.Item
    

    
    
    
    var body: some View {
        Text(item.rawValue.capitalized)
//        .swipeActions {
//            
//            Button(role: .destructive) {
//                Folder.delete(folder)
//            } label: {
//                Label("Delete", systemImage: "trash")
//            }
//            
//            Button(action: {
//                startRenameAction()
//            }, label: {
//                Label("Rename", systemImage: "pencil")
//            })
//            
//        }
//        .contextMenu {
//            
//            Button("Rename") {
//                startRenameAction()
//            }
//            Button("Delete") {
//                Folder.delete(folder)
//            }
//        }
//        .sheet(isPresented: $showRenameEditor, content: {
//            FolderEditorView(folder: folder)
//        })

    }
}
