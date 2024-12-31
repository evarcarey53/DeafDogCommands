//
//  ShowSettings.swift
//  Oliver
//
//  Created by Eva Carey on 05/28/24.
//

import SwiftUI

struct ShowSettings: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isButtonTapped = true
    @State var removeCommand = false
    @State var addCommand = false
    @State var changeCommand = false
    
    @State private var showRemoveCommand = false

    // Create a shared command selection manager
    @StateObject var commandSelectionManager = CommandSelectionManager()

    var body: some View {
        ZStack {
            // Background
            Image("dogbackground") // Fix for the background image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                // Title text
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50.0)
                
                // Connect to Device Section
                HStack {
                    Button {
                        // Action for connecting to the device
                    } label: {
                        Image(systemName: "app.connected.to.app.below.fill")
                            .foregroundStyle(.black)
                            .font(.largeTitle)
                    }
                    Button(action: {
                        // Connect to device action
                    }) {
                        Text("Connect to Device")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(20)
                            .foregroundColor(isButtonTapped ? .gray : .black)
                            .cornerRadius(10)
                    }
                    .disabled(isButtonTapped) // Disable button after tapped
                }
                
                // Add Command Section
                HStack {
                    Button {
                        // Action for adding a command
                    } label: {
                        Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                            .foregroundStyle(.black)
                            .font(.largeTitle)
                    }
                    Button(action: {
                        // Add command action
                        addCommand.toggle()
                    }) {
                        Text("Add Command")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.all, 20)
                            .padding(.trailing, 35)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                
                // Remove Command Section
                HStack {
                    Button {
                        // Action for removing a command
                    } label: {
                        Image(systemName: "rectangle.fill.badge.minus")
                            .foregroundStyle(.black)
                            .font(.largeTitle)
                    }
                    Button(action: {
                        removeCommand.toggle()
                    }) {
                        Text("Remove Command")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(20)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                
                // Change Command Section
                HStack {
                    Button {
                        // Action for changing a command
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(.black)
                            .font(.largeTitle)
                    }
                    Button(action: {
                        // Change command action
                        changeCommand.toggle()
                    }) {
                        Text("Change Command")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(20)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 200.0)
                
                // Done Button
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .font(.title3)
                .foregroundStyle(.white)
            }
            .foregroundStyle(.black) // Ensure dark mode uses black text
            
            // Sheet for RemoveCommand
            .sheet(isPresented: $removeCommand) {
                RemoveCommand(commandSelectionManager: commandSelectionManager)
            }
            .sheet(isPresented: $addCommand) {
                AddCommand()
            }
            .sheet(isPresented: $changeCommand) {
                ChangeCommand()
            }
        }
    }
}

#Preview {
    ShowSettings()
}
