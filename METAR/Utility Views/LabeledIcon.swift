//
//  LabeledIcon.swift
//  METAR
//
//  Created by Charles Duyk on 7/8/22.
//

import SwiftUI

struct LabeledIcon<IconType: View>: View{
    let icon: IconType
    let label: String
    
    var body: some View {
        VStack{
            icon
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
        let wind = Image(systemName: "wind")
        let fetching = Image(systemName: "arrow.triangle.2.circlepath")
        LabeledIcon(icon: wind, label: "120 @ 5 kts")
        LabeledIcon(icon: fetching, label: "Fetching")
    }
}
