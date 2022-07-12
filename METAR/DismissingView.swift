//
//  SheetDismisser.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI

struct DismissingView <Content : View> : View {
    private var content : Content
    private var dismissButtonTitle: String
    @Environment(\.dismiss) private var dismiss
    
    init(buttonTitle: String = "Done", @ViewBuilder content: () -> Content) {
        self.dismissButtonTitle = buttonTitle
        self.content = content()
    }
    
    var body: some View {
        content
            .navigationBarItems(trailing: Button(self.dismissButtonTitle) {
                self.dismiss()
            })
    }
}

struct DismissingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DismissingView {
                Text("Hello")
            }
        }
    }
}
