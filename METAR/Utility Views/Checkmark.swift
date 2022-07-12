//
//  Checkmark.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

struct Checkmark: View {
    let checked: Bool
    let baseFont: Font = .title
    
    private var imageName: String {
        get {
            return checked ? "checkmark.circle.fill" : "circle"
        }
    }
    
    var body: some View {
        Image(systemName:imageName)
            .foregroundColor(checked ? .accentColor : .gray)
            .font(checked ? baseFont : baseFont.weight(.ultraLight))
    }
}

struct Checkmark_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Checkmark(checked: false)
            Checkmark(checked: true)
        }
    }
}
