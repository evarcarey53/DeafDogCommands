//
//  RemoveCommand.swift
//  Oliver
//
//  Created by Eva Carey on 05/29/24.
//
import Foundation
import SwiftUI

// Define the Command enum
enum Command: String, Identifiable, CaseIterable {
    case stop, off, danger, no, stay, dropit, sit, quiet, comehere

    var id: String { self.rawValue }

    // Return a description for each command
    var description: String {
        switch self {
        case .stop: return "STOP"
        case .off: return "OFF"
        case .danger: return "DANGER"
        case .no: return "NO"
        case .stay: return "STAY"
        case .dropit: return "DROP IT"
        case .sit: return "SIT"
        case .quiet: return "QUIET"
        case .comehere: return "COME HERE"
        }
    }
}

// Command selection manager
class CommandSelectionManager: ObservableObject {
    @Published var ipAddress: String = ""
    @Published var allCommands: [Command] = Command.allCases // Initialize with all commands
    @Published var uncheckedCommands: [Command] = Command.allCases
    @Published var selectedCommands: [Command] = [] // Tracks selected commands for removal

    // Toggle selection state for a command
    func toggleSelection(for command: Command) {
        if selectedCommands.contains(command) {
            selectedCommands.removeAll { $0 == command }
        } else {
            selectedCommands.append(command)
        }
    }

    // Remove selected commands from the uncheckedCommands list
    func removeSelectedCommands() {
        uncheckedCommands.removeAll { selectedCommands.contains($0) }
        selectedCommands.removeAll() // Clear the selected commands
    }
}

// View for removing commands
struct RemoveCommand: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var commandSelectionManager: CommandSelectionManager

    var body: some View {
        NavigationView {
            VStack {
                // List of commands with checkboxes
                List(commandSelectionManager.allCommands, id: \.self) { command in
                    HStack {
                        Text(command.description)
                            .font(.title3)
                            .foregroundColor(.primary)
                        Spacer()
                        // Toggle selection
                        Image(systemName: commandSelectionManager.selectedCommands.contains(command) ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                commandSelectionManager.toggleSelection(for: command)
                            }
                            .foregroundColor(.cyan)
                    }
                }
                .listStyle(PlainListStyle())

                Spacer()

                // Remove button
                Button(action: {
                    commandSelectionManager.removeSelectedCommands()
                    dismiss() // Dismiss the view
                }) {
                    Text("Remove")
                        .padding(5)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Commands")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    RemoveCommand(commandSelectionManager: CommandSelectionManager())
}
