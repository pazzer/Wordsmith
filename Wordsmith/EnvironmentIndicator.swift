//
//  IsLiveVersionIndicator.swift
//  Wordsmith
//
//  Created by Paul Patterson on 24/08/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct EnvironmentIndicator: View {
    
    struct AlertModel {
        let title: String
        let message: String
    }
    
    @State var showInfo = false
    
    @State var animate: Bool = false
    
    @Environment(\.modelContext) var context
    
    @State var viewModel = ViewModel()
    
    @State var opacity = 1.0
    
    var body: some View {
        HStack {
            Button(action: {
                showInfo.toggle()
            }, label: {
                Label(viewModel.indicatorLabel, systemImage: viewModel.indicatorImage)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.indicatorForeground)
                    .opacity(opacity)
                    
            })
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 16)
            .padding(.vertical, 12)
            Spacer()
        }
        .background(viewModel.indicatorBackground)
        
        .alert(isPresented: $showInfo, content: {
            Alert(title: Text(viewModel.alertModel.title), message: Text(viewModel.alertModel.message))
        })
        
        .onAppear {
            if viewModel.pulse {
                DispatchQueue.main.async {
                    withAnimation(Animation.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                        self.opacity = 0.33
                    }
                }
            }
        }
        
        
        .animation(.easeIn(duration: 1).repeatForever(autoreverses: true), value: animate)
    }
    
    struct ViewModel {
        
        let alertModel: AlertModel
        let indicatorImage: String
        let indicatorLabel: String
        let indicatorBackground: Color
        let indicatorForeground: Color
        let pulse: Bool
        
        init() {
            
            
            let title: String
            let message: String
            if WordsmithApp.configuration == .personal && WordsmithApp.launchedFromXcode && WordsmithApp.storingDataOnDisc {
                indicatorLabel = "Danger"
                indicatorImage = "exclamationmark.triangle"
                indicatorBackground = .red
                indicatorForeground = .white
                title = "Using in-memory"
                message = "Proceed with extreme caution. Changes made here will be saved to your personal Wordsmith database."
                pulse = true
            } else {
                indicatorLabel = WordsmithApp.configuration.rawValue.capitalized
                indicatorImage = WordsmithApp.storingDataOnDisc ? "opticaldiscdrive.fill" : "brain.head.profile.fill"
                if WordsmithApp.configuration == .debug || !WordsmithApp.storingDataOnDisc {
                    indicatorBackground = .gray
                    indicatorForeground = .white
                } else {
                    indicatorBackground = .black
                    indicatorForeground = .yellow
                }
                title = WordsmithApp.storingDataOnDisc ? "Using on-disc storage" : "Using in-memory storage"
                message = WordsmithApp.storingDataOnDisc ? "Changes will be saved." : "Changes will not be saved."
                pulse = false
            }
            
            alertModel = .init(title: title, message: message)

            
            
        }
        
    }
}

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
    }
}
