//
//  Checkmark.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

struct Checkmark: View {
    enum Style {
        case plain
        case filledCircle
        
        @ViewBuilder fileprivate func viewWhen(_ checked: Bool) -> some View {
            if checked {
                self.checked()
            }
            else {
                self.unchecked()
            }
        }
        
        @ViewBuilder private func checked() -> some View {
            switch(self) {
            case .plain:
                Image(systemName:"checkmark")
                    .foregroundColor(.accentColor)
                    .font(.body)
            case .filledCircle:
                Image(systemName:"checkmark.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.title)
            }
        }
        
        @ViewBuilder private func unchecked() -> some View {
            switch(self) {
            case .plain:
                EmptyView()
            case .filledCircle:
                Image(systemName:"circle")
                    .font(.title.weight(.ultraLight))
                    .foregroundColor(.gray)
            }
        }
    }
    
    let checked: Bool
    let style: Style
    
    internal init(checked: Bool, style: Checkmark.Style = .plain) {
        self.checked = checked
        self.style = style
    }
    
    var body: some View {
        self.style.viewWhen(self.checked)
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
