//
//  DetailView.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/1/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct DetailView: View {
    
    @EnvironmentObject var settings: SettingsStorage
    @State private var showFilterPopover: Bool = false
    @State private var showCEOPopover: Bool = false
    @ObservedObject var model = DetailModel()
    @State var showIEXAlert = false
    @State var selectedIndexes: [Int]?
    var detailStock: Stock
    
    var body: some View {
        VStack {
            // chart group
            Group {
//                MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)],
//                                   title: "Test",
//                                   legend: "Test",
//                                   style: ChartStyle(formSize: CGSize(width: 1000, height: 1000)),
//                                   form: ChartForm.large,
//                                   rateValue: nil,
//                                   dropShadow: false,
//                                   valueSpecifier: "Test")
                // TODO: fullscreen chart for ios landscape
                ChartViewController(stockToFetchDataFor: detailStock).modifier(SystemServices())
                    .frame(minWidth: 200, idealWidth: .infinity)
                    .padding([.leading, .trailing], 10)
//                XAxisLabelView(StartOfAxisDate: Date()).modifier(SystemServices())
//                    .padding(.bottom)
            }
//            .onAppear(perform: {
//                print(model.$historicalData.count())
//                if let x = self.detailStock.days?.allObjects as? [Day] {
//                    if x.isEmpty {
//                        print("stock has no data")
//                        // TODO: uncomment
////                        self.model.fetchHistoricalData(stock: self.detailStock)
//                    }
//                }
//            })
//            .onAppear(perform: {
//                // TODO: get new data if older than 1 day
////                print(self.model.stockData)
////                print(self.model.shouldUpdateWithNonCoreData)
//                if (self.detailStock.days?.allObjects as! [Day]).isEmpty && self.model.stockData.isEmpty {
//                    // TODO: fetch core data Stock with same symbol and set detailStock to that
//                    print("no data, getting some...")
//                    self.model.getHistoricalData(from: self.detailStock.symbol!)
////                    self.detailStock.days = NSSet(object: self.model.stockData)
////                    self.updateForNewdata = true
//                }
//            })
            // premium ad group
            if !self.settings.isPro {
                Group {
                    Text(Translation.content_Premium_MoreThan5Filter)
                        .padding()
                    Button(Translation.upgrade_Button) { print("upgrade") }
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: 200)
                        .buttonStyle(FilledBlueButton())
                        .padding()
                }
            }
            Divider()
            // information group
            Group {
                // link to https://iexcloud.io
                Button(Translation.PROVIDED_BY_IEX) { self.showIEXAlert = true }
                    .foregroundColor(Color(UIColor.systemGray3))
            }.padding()
        .navigationBarTitle(Text("\(detailStock.name ?? "error")"), displayMode: .inline)
        .navigationBarItems(leading:
            HStack {
                // TODO: NavigationLink to fullscreen graph
                Button( action: { print("expand/minimize") } ) { Image(systemName: "arrow.up.left.and.arrow.down.right") }
                //Button("Download Data") { self.model.getHistoricalData(from: self.detailStock.symbol!) }
                Spacer()
            }
            ,trailing: HStack {
                Button( action: { self.showCEOPopover = true }){ Image(systemName: "person") }.popover(isPresented: self.$showCEOPopover) { CEOPopoverView(symbol: self.detailStock.symbol!).modifier(SystemServices()) }.disabled(!settings.isPro)
                Button( action: { self.showFilterPopover = true }){ Image(systemName: "line.horizontal.3.decrease.circle") }.popover(isPresented: self.$showFilterPopover) { FilterPopoverView().modifier(SystemServices()) }.disabled(!settings.isPro)
                Button( action: { self.saveAsFavorite() } ) { if detailStock.isFavorite { Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemOrange)) } else { Image(systemName: "star") } }
            }
            )
        }
    }
    
//    func checkStockData(stock: Stock) -> Stock {
//        if (stock.days?.allObjects as! [Day]).isEmpty {
//            model.getHistoricalData(from: stock.symbol!)
//
//            return stock
//        }
//        else {
//            print("found stock data")
//            return stock
//        }
//    }
    
    func saveAsFavorite() {
        print("setting as favorite...")
        let context = detailStock.managedObjectContext
        context?.performAndWait {
            detailStock.isFavorite = !detailStock.isFavorite
            do {
                try context?.save()
                print("saved favorite status to core data")
            }
            catch {
                print("unable to save favorite status to core data")
            }
        }
    }
    
}

struct LineChartSwiftUI: UIViewRepresentable {
    let chart = LineChartView()
    
    func makeUIView(context: Context) -> some UIView {
        <#code#>
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        <#code#>
    }
    
    
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(detailStock: createPreviewStock())
//    }
//}
//
