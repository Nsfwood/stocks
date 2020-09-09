//
//  CEOPopoverView.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/5/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct CEOPopoverView: View {
    @ObservedObject var model = CEOPopoverModel()
    var symbol: String
    
    var body: some View {
        Form {
            HStack {
                Text("CEO Name:")
                Spacer()
                Text("\(model.ceoData?.name ?? "___")")
            }
            HStack {
                Text("Location:")
                Spacer()
                Text("\(model.ceoData?.location ?? "___")")
            }
            HStack {
                Text("Salary:")
                Spacer()
                Text("$\(model.ceoData?.salary ?? 0)")
            }
            HStack {
                Text("Bonus:")
                Spacer()
                Text("$\(model.ceoData?.bonus ?? 0)")
            }
            HStack {
                Text("Total:")
                Spacer()
                Text("$\(model.ceoData?.total ?? 0)")
            }
            HStack {
                Text("For the year \(model.ceoData?.year ?? "___")")
            }
        }
            .frame(width: 400, height: 400)
            .onAppear(perform: {
                self.model.getCEOData(from: self.symbol)
            })
    }
}

struct CEOPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        CEOPopoverView(symbol: "AAPL")
    }
}
