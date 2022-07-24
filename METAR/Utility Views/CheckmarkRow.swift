//
//  CheckmarkRow.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

struct CheckmarkRow <Content : View> : View {
    let checked: Bool
    let checkmarkStyle: Checkmark.Style
    var content: Content

    
    init(checked: Bool, checkmarkStyle: Checkmark.Style = .plain, @ViewBuilder content: () -> Content) {
        self.checked = checked
        self.checkmarkStyle = checkmarkStyle
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 10) {
            content
            Spacer(minLength: 0)
            Checkmark(checked:checked, style: self.checkmarkStyle)
        }
        .contentShape(Rectangle())
    }
}

struct CheckmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CheckmarkRow(checked: true) {
                Text("Checked")
            }
            CheckmarkRow(checked: false) {
                Text("Unchecked")
            }
        }
    }
}
