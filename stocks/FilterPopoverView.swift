//
//  FilterPopoverView.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/30/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct FilterPopoverView: View {
    
    @State private var xStart = Date()
    @State private var xEnd = Date()
    @State private var yStart = ""
    @State private var yEnd = ""
    
    var body: some View {
        Form {
            Section(header: Text("X Range")) {
                DatePicker(selection: $xStart, in: ...Date(), displayedComponents: .date) {
                    Text("X Axis Start Date")
                }
                DatePicker(selection: $xEnd, in: ...Date(), displayedComponents: .date) {
                    Text("X Axis End Date")
                }
//                TextField("Start of X Range (Must be a number)", text: $xStart)
//                TextField("End of X Range (Must be a number)", text: $xEnd)
            }
            Section(header: Text("Y Range")) {
                TextField("Start of Y Range (Must be a number)", text: $yStart)
                TextField("End of Y Range (Must be a number)", text: $yEnd)
            }
        }
    }
}

struct FilterPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        FilterPopoverView()
    }
}
