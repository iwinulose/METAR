//
//  DismissableSheet.swift
//  METAR
//
//  Created by Charles Duyk on 7/9/22.
//

import SwiftUI


struct DismissableSheet <Content : View> : View {
    var content : Content
    var dismissButtonTitle: String
    @Environment(\.presentationMode) var presentationMode
    
    init(buttonTitle: String = "Done", @ViewBuilder content: () -> Content) {
        self.dismissButtonTitle = buttonTitle
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarItems(trailing: Button("Done") { self.dismiss() })
        }
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct DismissableSheet_Previews: PreviewProvider {
    static var previews: some View {
        DismissableSheet {
            Text("Hello")
        }
    }
}
