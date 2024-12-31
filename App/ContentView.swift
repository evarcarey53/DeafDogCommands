//
//  ContentView.swift
//
//
//  Created by Eva Carey on 05/19/24.
//

import SwiftUI
import Network

struct ContentView: View {
    @State private var showInfo = false
    @State private var showSettings = false
    @State private var cmdName: String = ""
    @State private var statusMessage = "Send Data"
    
    @StateObject private var commandSelectionManager = CommandSelectionManager()

    let buttonsPerRow = 3
    
    var body: some View {
        ZStack {
            // Background image
            Image("bostonterrier")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                // Settings button
                HStack {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 330)
                }
                
                Text("Tap Command\n\n")
                    .font(.system(size: 45, weight: .bold))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .kerning(4)
                    .padding(.top, 40)
                
                // Create rows of buttons
                ForEach(createButtonRows(using: commandSelectionManager.uncheckedCommands), id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { command in
                            Button(action: {
                                sendDataToPicoW(cmdName: command.description)
                            }) {
                                Text(command.description)
                                    .buttonStyle()
                            }
                        }
                    }
                }
                Spacer()
                // Info button
                HStack {
                    Button {
                        showInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 330)
                }
            }
            .foregroundColor(.black)
            .sheet(isPresented: $showInfo) {
                ShowInfo()
            }
            .sheet(isPresented: $showSettings) {
                ShowSettings(commandSelectionManager: commandSelectionManager)
            }
        }
        .onAppear {
            discoverDeviceIP { ip in
                if let ip = ip {
                    DispatchQueue.main.async {
                        commandSelectionManager.ipAddress = ip
                        statusMessage = "Device found at \(ip)"
                    }
                } else {
                    DispatchQueue.main.async {
                        statusMessage = "Device not found"
                    }
                }
            }
        }
    }
    
    func sendDataToPicoW(cmdName: String) {
        guard !commandSelectionManager.ipAddress.isEmpty else {
            print("IP address is empty")
            DispatchQueue.main.async {
                statusMessage = "IP address is empty"
            }
            return
        }

        guard let url = URL(string: "http://\(commandSelectionManager.ipAddress)/") else {
            print("Invalid URL")
            DispatchQueue.main.async {
                statusMessage = "Invalid URL"
            }
            return
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: ["command": cmdName]) else {
            print("Failed to serialize data")
            DispatchQueue.main.async {
                statusMessage = "Failed to serialize data"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    statusMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    statusMessage = "Response: \(responseString)"
                }
            } else {
                DispatchQueue.main.async {
                    statusMessage = "No response from server"
                }
            }
        }
        task.resume()
    }

    func discoverDeviceIP(completion: @escaping (String?) -> Void) {
        let broadcastAddress = NWEndpoint.Host("255.255.255.255")
        let port: NWEndpoint.Port = 12345
        let discoveryMessage = "DISCOVER_PICOW"
        
        let connection = NWConnection(host: broadcastAddress, port: port, using: .udp)
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                let data = discoveryMessage.data(using: .utf8) ?? Data()
                connection.send(content: data, completion: .contentProcessed { error in
                    if let error = error {
                        print("Send error: \(error)")
                        completion(nil)
                    }
                })
            case .failed(let error):
                print("Connection failed: \(error)")
                completion(nil)
            default:
                break
            }
        }
        
        connection.receiveMessage { data, _, _, error in
            if let error = error {
                print("Receive error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let response = String(data: data, encoding: .utf8) {
                completion(response)
            } else {
                completion(nil)
            }
            connection.cancel()
        }
        connection.start(queue: .global())
    }
    
    func createButtonRows(using uncheckedCommands: [Command]) -> [[Command]] {
        uncheckedCommands.chunked(into: buttonsPerRow)
    }
}

// Extension for chunking an array into smaller arrays
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// Modifier for Consistent Button Style
extension Text {
    func buttonStyle() -> some View {
        self
            .frame(width: 120, height: 70)
            .font(.headline)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
