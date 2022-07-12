//
//  WelcomeView.swift
//  METAR
//
//  Created by Charles Duyk on 7/10/22.
//

import SwiftUI

struct WelcomeView: View {
    private let interItemSpacing = 30.0
    private let edgeInsetRatio = 0.05
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Welcome to Mighty")
                    .font(.largeTitle.weight(.semibold))
                    .padding(.bottom, interItemSpacing)
                Text("Mighty is the easiest way to see aviation weather at a glance. Add an airport to get started.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, interItemSpacing)
                    .padding(.horizontal, geometry.size.width * edgeInsetRatio)
                Spacer()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
