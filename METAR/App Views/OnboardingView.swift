//
//  OnboardingView.swift
//  METAR
//
//  Created by Charles Duyk on 7/11/22.
//

import SwiftUI

struct OnboardingView: View {
    let stationInfo: StationInfo
    
    @EnvironmentObject var model: AppModel
    
    var body: some View {
        VStack {
            Text("You can change this at any time in Settings.")
                .font(.subheadline)
            METARRowStylePicker(
                selectedRowStyle: self.$model.preferredRowStyle,
                stationInfo: stationInfo
            )
        }
        .background(Color(UIColor.secondarySystemBackground))
        .navigationTitle("Choose a row style")
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(stationInfo: StationInfo.dummy("PHNL"))
    }
}
