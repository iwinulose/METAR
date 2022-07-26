//
//  CasePicker.swift
//  METAR
//
//  Created by Charles Duyk on 7/24/22.
//

import SwiftUI

typealias Pickable = CaseIterable & CustomStringConvertible & Equatable & Identifiable

struct CasePicker<T: Pickable>: View where T.AllCases : RandomAccessCollection {
    @Binding var selected: T

    var body: some View {
        List {
            ForEach (T.allCases) { value in
                CheckmarkRow(checked: self.selected == value) {
                    Text(value.description)
                }
                .onTapGesture {
                    self.selected = value
                }
            }
        }
    }
}

struct CasePicker_Previews: PreviewProvider {
    static var previews: some View {
//        enum Test: String {
//            case first, second, third
//        }
//        @State var currentTest = Test.first
//
//        CasePicker(selected: $currentTest)
        Text("Test")
    }
}
