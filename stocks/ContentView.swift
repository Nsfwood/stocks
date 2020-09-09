//
//  ContentView.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/25/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

// TODO: limit ability to add more than 3 stocks to premium

struct ContentView: View {
    @EnvironmentObject var settings: SettingsStorage
    @State private var showAddModel = false
    @State private var showSettingsModel = false
    
    @Environment(\.managedObjectContext)
    var viewContext   
 
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text(Translation.sidebar_Navigation_Bar_Title)) // Stocks
                .navigationBarItems(
                    leading: HStack {
                        Button(action: { print("settings"); self.showSettingsModel = true } ) { Image(systemName: "gear") }.sheet(isPresented: self.$showSettingsModel) {
                            SettingsView(isPresented: self.$showSettingsModel)
                                .modifier(SystemServices())
                        }
                    },
                    trailing: Button(
                        action: {
                            self.showAddModel = true
                            print("add button pressed")
                        }
                    ) { Image(systemName: "plus.circle") }
                        .disabled(settings.savedStocks > 2 && !settings.isPro)
                        .sheet(isPresented: self.$showAddModel) { AddModalView().environment(\.managedObjectContext, self.viewContext).modifier(SystemServices()) }
                )
            Text(Translation.content_NoStock_Body) // Select a stock to view it's graph.
                .navigationBarTitle(Text(Translation.content_Navigation_Bar_Title))
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @EnvironmentObject var settings: SettingsStorage
    @ObservedObject var model = ChartModel()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Stock.isFavorite, ascending: false), NSSortDescriptor(keyPath: \Stock.name, ascending: true)],
        animation: .default)
    var stocks: FetchedResults<Stock>
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    var body: some View {
//        Button("Test") { print("\(self.stocks.count) stocks saved to core data") }
        List {
            if stocks.isEmpty {
                Text(Translation.sidebar_Item_AddPrompt) // Press the 􀁌 button to add a stock to your portfolio.
            }
            ForEach(stocks, id: \.self) { stock in
                NavigationLink(destination: DetailView(detailStock: stock)) {
                    HStack {
                        if self.settings.stockLogo {
                            Group { () -> AnyView in
                                if let i = stock.logo {
                                    if let ui = UIImage(data: i) {
                                        return AnyView(
                                            Image(uiImage: ui).resizable().scaledToFit().frame(width: 40, height: 40).cornerRadius(8)
                                        )
                                    }
                                    else {
                                        return AnyView(
                                            Image("logo.missing")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 40)
                                                .cornerRadius(8)
                                        )
                                    }
                                }
                                else {
                                    return AnyView(Image("logo.missing").resizable().scaledToFit().frame(height: 40).cornerRadius(8))
                                }
                            }
                        }
                        Text("\(stock.symbol ?? "error")")
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Spacer()
                        if stock.isFavorite {
                            Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemOrange))
                        }
                        Text(getCurrencyFormat(from: self.getLastClose(from: stock))) // String(format: "$%.2f", self.getLastClose(from: stock))
                            .lineLimit(1)
                    }.onAppear(perform: {
                        self.settings.savedStocks = self.stocks.count
                        // TODO: update all symbols and historical data
                    })
                }
            }
            .onDelete { indices in
                self.stocks.delete(at: indices, from: self.viewContext)
            }
        }
    }
    
    func updateStockData(stock: Stock) {
//        model.getHistoricalData(from: stock.symbol!)
    }
    
    func deleteStock() {
        
    }
    
    func getLastClose(from stock: Stock) -> Double {
//        print("getting last closing price")
//        return 0.0
        let sorted = (stock.days?.allObjects as? [Day])?.sorted { $0.date! < $1.date! }

//        for x in sorted! {
//            print("\(stock.symbol), \(x.close), \(x.date)")
//        }

//        if let s = sorted?.isEmpty {
//            print("data for \(stock.symbol): \(s)")
//            print(sorted)
//        }

        if let s = sorted?.last {
            return s.close
        }
        else {
            return 0.0
        }
        
    }
}

//struct DetailView: View {
//    @ObservedObject var settings: SettingsStore = SettingsStore()
//    @State private var showFilterPopover: Bool = false
////    @ObservedObject var stock: Stock
//    @ObservedObject var model = DetailModel()
//    @State var showIEXAlert = false
//    @Binding var detailStock: Stock
//
//    var data = [2020, 2019, 2018, 2017, 2016, 2015, 2014, 2013, 2012, 2011, 2010]
//    
//    var body: some View {
//        VStack {
//            ChartView(stockToFetchDataFor: $detailStock)
//            XAxisLabelView()
//            .frame(minWidth: 0, maxWidth: .infinity)
//            .padding(.bottom)
//            if !settings.isPro {
//                Group {
//                    HStack {
//                        Text("Upgrade to Premium to view more than 5 years and filter the chart")
//                        Button("Upgrade to Premium") { print("upgrade") }
//                            .frame(minWidth: 100, idealWidth: 100, maxWidth: 200, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
//                            .buttonStyle(FilledBlueButton())
//                    }
//                    
//                }.padding()
//            }
//            Divider()
//            Button("Data provided by IEX Cloud") { self.showIEXAlert = true } // link to https://iexcloud.io
//                .foregroundColor(Color(UIColor.systemGray3))
//            .actionSheet(isPresented: $showIEXAlert) {
//                ActionSheet(
//                    title: Text("IEX Cloud"),
//                    message: Text("Open iexcloud.io in Safari?"),
//                    buttons: [ .cancel(), .default(Text("Yes")) { print("open safari") } ] )
//            }
//        }
//        .navigationBarTitle(Text("\(detailStock.name ?? "error")"), displayMode: .inline)
//        .navigationBarItems(leading:
//            HStack {
//                Button( action: { print("expand/minimize") } ) { Image(systemName: "arrow.up.left.and.arrow.down.right") }
//                Button("Download Data") { self.model.getHistoricalData(from: self.detailStock.symbol!) }
//            }
//            ,trailing: HStack { Button("Show popover") { self.showFilterPopover = true }.popover(isPresented: self.$showFilterPopover) { FilterPopoverView() }
//                Button( action: { print("favorite") } ) { Image(systemName: "star") }
//            }
//            )
//            .padding(.all, 20)
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
