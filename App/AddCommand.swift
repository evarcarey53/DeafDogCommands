//
//  AddCommand.swift
//
//
//  Created by Eva Carey on 05/28/24.
//

import SwiftUI

struct AddCommand: View {
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
                Text("Page Under Construction\n")
                    .font(.title)
                    .fontWeight(.bold)
                
                // description text
                Text("Planned enhancement for version 2.0\n\n\n\n")
                    .font(.title3)
                    .padding(.horizontal, 30)

                
                // Done button
                Button("Done"){
                    dismiss()
                }
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
    AddCommand()
}
