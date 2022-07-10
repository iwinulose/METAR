//
//  CheckmarkRow.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

struct CheckmarkRow <Content : View> : View {
    let checked : Bool
    var content : Content

    
    init(checked: Bool, @ViewBuilder content: () -> Content) {
        self.checked = checked
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 10) {
            content
            Checkmark(checked:checked)
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
