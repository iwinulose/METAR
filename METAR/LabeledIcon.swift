//
//  InfoIcon.swift
//  METAR
//
//  Created by Charles Duyk on 7/8/22.
//

import SwiftUI

struct LabeledIcon: View {
    let systemImageName: String
    let label: String
    
    var body: some View {
        VStack{
            Image(systemName:systemImageName)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                .font(.title)
            Text(label)
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
        }

    }
}

struct InfoIcon_Previews: PreviewProvider {
    static var previews: some View {
        LabeledIcon(systemImageName: "wind", label: "120 @ 5 kts")
    }
}
