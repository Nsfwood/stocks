////
////  ChartView.swift
////  stocks
////
////  Created by Alexander Rohrig on 7/27/20.
////  Copyright © 2020 Alexander Rohrig. All rights reserved.
////
//
//import SwiftUI
//
//public struct ZanderChartView: View {
//    
//    var data: [Day]
////    var data: HistoricalPrices
//    
////    var yMin: Double {
////        if let min = data.flatMap({$0.onlyPoints()}).min() {
////            return min
////        }
////        return 0
////    }
////    
////    var yMax: Double {
////        if let max = data.flatMap({$0.onlyPoints()}).max() {
////            return max
////        }
////        return 0
////    }
//    
//    public init(data: [Day]) {
//        self.data = data
//    }
//    
//    public var body: some View {
//        GeometryReader{ geometry in
//            ZStack{
//                ForEach(0..<self.data.count) { i in
//                    Line(data: self.data[i],
//                         frame: .constant(geometry.frame(in: .local)),
//                         touchLocation: self.$touchLocation,
//                         showIndicator: self.$showIndicatorDot,
//                         minDataValue: .constant(self.globalMin),
//                         maxDataValue: .constant(self.globalMax),
//                         showBackground: false,
//                         gradient: self.data[i].getGradient(),
//                         index: i)
//                }
//            }
//        }
//    }
//    
//}
//
//struct ChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZanderChartView(data: createDaysForPreviewStock())
//    }
//}
