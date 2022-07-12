//
//  TwoItemRow.swift
//  METAR
//
//  Created by Charles Duyk on 9/24/20.
//

import SwiftUI

struct TwoItemRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title).bold()
            Spacer()
            Text(value)
        }
    }
}

struct TwoItemRow_Previews: PreviewProvider {
    static var previews: some View {
        TwoItemRow(title:"Title", value:"Value")
    }
}
