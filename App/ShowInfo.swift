//
//  ShowInfo.swift
//  
//
//  Created by Eva Carey on 05/28/24.
//

import SwiftUI

struct ShowInfo: View {
    @Environment(\..dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // background
            Image(.dogbackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack {
                // title text
                Text("Info\n")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // description text
                Text("The Deaf Dog Commands App allows you to tap a command to send to your dogs collar. \n\nPlease make sure the collar has been paired with the App first (see Settings). \n\nYou can add new commands, remove commands, and change commands via the Settings.\n\nFuture enhancements will include voice activation and commands.\n")
                    .font(.title3)
                    .padding(.horizontal, 15)
                Text("This collar was created to assist the training of deaf dogs and to allow a way to communicate with them. One way to communicate with a deaf dog is through sign language but when a dog is not looking at you or in sight, it is sometimes crucial to be able to communicate with them. Especially in a dangerous situation. This collar allows you to send commands to the dog via the collar. Once trained, the dog will understand what each comamnd means. For training tips and videos, Please visit:")
                    .font(.callout)
                    .padding(.horizontal, 15)
                Link("Deaf Dog Commands", destination: URL(string: "https://www.deafdogcommands.com")!)
                    .foregroundColor(.blue)
                
                // Done button
                Button("Done"){
                    dismiss()
                }.padding(.top,50)
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .font(.title3)
                .foregroundStyle(.white)
            }
            .foregroundStyle(.black) // so dark mode is black text instead of white
        }
    }
}

#Preview {
    ShowInfo()
}
