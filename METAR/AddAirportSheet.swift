//
//  AddAirportSheet.swift
//  METAR
//
//  Created by Charles Duyk on 9/20/20.
//

import SwiftUI

import AviationWeather

struct AddAirportSheet: View {
    let stations: [Station]
    let selection: Binding<Station?>
    let showsOnboardingAfterSelection: Bool
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showOnboarding = false
    
    var body: some View {
        NavigationView {
            DismissingView {
                VStack {
                    AirportPicker(stations:self.stations,
                                  selection:self.selection,
                                  airportPicked: self.handleAirportPicked)
                    NavigationLink(isActive: self.$showOnboarding, destination: {
                        OnboardingView(stationInfo: StationInfo.dummy(self.selection.wrappedValue?.id ?? "KIAD"))
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(trailing: Button("Done") {
                                self.dismiss()
                            })
                    }, label: { EmptyView() })
                }
                .navigationBarTitle("Add Airport")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func handleAirportPicked() {
        if (self.showsOnboardingAfterSelection && self.selection.wrappedValue != nil) {
            self.showOnboarding = true
        }
        else {
            self.dismiss()
        }
    }
}

//struct AddStationSheet_Previews: PreviewProvider {
//    @State var selection: String?
//    
//    static var previews: some View {
//        let stations = ["KSFO", "KSTS"]
//        AddStationSheet(stations: stations, selectedStation:$selection)
//    }
//}
