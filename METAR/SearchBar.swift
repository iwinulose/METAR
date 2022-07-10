//
//  SearchBar.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search ...", text:self.$text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                        if isEditing {
                            Spacer()
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                }, alignment: .leading)
                .padding(.horizontal, 10)
                .onTapGesture {
                        self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""

                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                // FIXME: .animation is deprecated, but I can't figure out how to use withAnimation (v1 OK)
                .animation(.default)
            }
        }
    }
}
