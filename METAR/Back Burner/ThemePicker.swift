//
//  ThemePicker.swift
//  METAR
//
//  Created by Charles Duyk on 7/20/22.
//

import SwiftUI

struct ThemePicker: View {
    @Binding var selectedTheme: Theme
    
    var body: some View {
        List {
            ForEach (Theme.allCases) { theme in
                CheckmarkRow(checked: self.selectedTheme == theme) {
                    Text(theme.description)
                }
                .onTapGesture {
                    self.selectedTheme = theme
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct ThemePicker_Previews: PreviewProvider {
    @State static var selectedTheme: Theme = .basic
    
    static var previews: some View {
        return ThemePicker(selectedTheme: self.$selectedTheme)
    }
}
