//
//  XAxisLabelView.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/1/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct XAxisLabelView: View {
    
    @EnvironmentObject var settings: SettingsStorage
    var StartOfAxisDate: Date
    
    let medList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let shortList = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
    
    func getMonthsInYearStartingToday(date: Date) -> [String] {
        let currentMonth = date.monthAsInt
        var returnArray: [String] = []
        var count = 0//currentMonth - 1
        
        if settings.startChartsAtJan1 {
            count = 0
        }
        
        while returnArray.count != 12 {
            if count == 12 {
                count = 0
            }
            returnArray.append(medList[count])
            count += 1
        }
        
        return returnArray
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(getMonthsInYearStartingToday(date: StartOfAxisDate), id: \.self) { item in
                    Text(item)
                        .foregroundColor(Color(UIColor.systemGray))
                        .frame(maxWidth: .infinity)
                }
            }
            //.frame(minWidth: 100, idealWidth: .infinity)
            HStack {
                Text("Oldest").foregroundColor(Color(UIColor.systemBlue))
                Text("Oldest + 1").foregroundColor(Color(UIColor.systemRed))
                Text("Oldest + 2").foregroundColor(Color(UIColor.systemIndigo))
                Text("Oldest + 3").foregroundColor(Color(UIColor.systemOrange))
                Text("Oldest + 4").foregroundColor(Color(UIColor.systemPink))
                Text("Oldest + 5").foregroundColor(Color(UIColor.systemTeal))
            }.padding()
        }
    }
}

struct XAxisLabelView_Previews: PreviewProvider {
    
    static var previews: some View {
        XAxisLabelView(StartOfAxisDate: Date())
            .previewDevice(PreviewDevice(rawValue: "iPhone XS"))
            .previewDisplayName("iPhone XS")
            .preferredColorScheme(.dark)
    }
}
