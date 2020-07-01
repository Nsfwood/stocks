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
    @State private var showAddModel = false
    @State private var showSettingsModel = false
    
    @Environment(\.managedObjectContext)
    var viewContext   
 
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("Stocks"))
                .navigationBarItems(
                    leading: HStack {
                        //EditButton()
                        Button(
                            action: {
                                print("settings")
                                self.showSettingsModel = true
                            }
                        ) {
                            Image(systemName: "gear")
                        }.sheet(isPresented: self.$showSettingsModel) {
                            SettingsView().environmentObject(SettingsStore())
                        }
                    },
                    trailing: Button(
                        action: {
                            self.showAddModel = true
                            print("add button pressed")
                        }
                    ) { 
                        Image(systemName: "plus.circle.fill")
                    }.sheet(isPresented: self.$showAddModel) {
                        AddModalView().environment(\.managedObjectContext, self.viewContext)
                    }
                )
            Text("Select a stock to view it's graph.")
                .navigationBarTitle(Text("No Stock Selected"))
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @ObservedObject var settings: SettingsStore = SettingsStore()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Stock.lastViewed, ascending: true)],
        animation: .default)
    var stocks: FetchedResults<Stock>
    
    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(stocks, id: \.self) { stock in
                NavigationLink(
                    destination: DetailView(stock: stock)
                ) {
                    HStack {
                        if self.settings.stockLogo {
                            Image("logo.\(stock.symbol!)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .cornerRadius(8)
                        }
                        Text("\(stock.symbol ?? "error")")
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Spacer()
                        Text(String(format: "$%.2f", self.getLastClose(from: stock)))
                            .lineLimit(1)
                    }
                }
            }
            .onDelete { indices in
                self.stocks.delete(at: indices, from: self.viewContext)
            }
        }
    }
    
    func deleteStock() {
        
    }
    
    func getLastClose(from stock: Stock) -> Double {
        
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
    
//    fileprivate func sortDaysData(stock: Stock) {
//        var sortedDays: [Day]?
//
//        if let days = stock.days {
//            let daysArray = days.allObjects as? [Day] {
//                sortedDays = daysArray.sorted(by: { (day1, day2) -> Bool in
//                    guard let date1 = day1.date else {
//                        fatalError("###\(#function): day is missing a date! \(day1)")
//                    }
//                    guard let date2 = day2.date else {
//                        fatalError("###\(#function): day is missing a date! \(day2)")
//                    }
//
//                    return name1.compare(name2) == .orderedAscending
//                })
//            }
//        }
//    }
    
}

// TODO: create iphone landscapr view that only shows graph

struct DetailView: View {
    @ObservedObject var settings: SettingsStore = SettingsStore()
    @State private var showFilterPopover: Bool = false
    @ObservedObject var stock: Stock
    @ObservedObject var model = DetailModel()
    @State var showIEXAlert = false

    var data = [2020, 2019, 2018, 2017, 2016, 2015, 2014, 2013, 2012, 2011, 2010]
    
    var body: some View {
        VStack {
            ChartView(stock: stock)
            // TODO: make seperate legend view
            HStack {
                HStack {
                    Text("Jan").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Feb").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Mar").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Apr").frame(minWidth: 0, maxWidth: .infinity)
                    Text("May").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Jun").frame(minWidth: 0, maxWidth: .infinity)
                }.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
                HStack {
                    Text("Jul").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Aug").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Sep").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Oct").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Nov").frame(minWidth: 0, maxWidth: .infinity)
                    Text("Dec").frame(minWidth: 0, maxWidth: .infinity)
                }.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
            }.frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
            .padding(.bottom)
            HStack {
//                Button("Favorite") { print("favorite") }
//                    .frame(minWidth: 100, idealWidth: 100, maxWidth: 200, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
//                    .buttonStyle(FilledOrangeButton())
                Button("Upgrade to Premium") { print("upgrade") }
                    .frame(minWidth: 100, idealWidth: 100, maxWidth: 200, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                    .buttonStyle(FilledBlueButton())
            }.padding()
            if !settings.isPro {
                Group {
                    Text("Upgrade to Premium to view more than 5 years and filter the chart")
                }
            }
            Divider()
            Button("Data provided by IEX Cloud") { self.showIEXAlert = true } // link to https://iexcloud.io
                .foregroundColor(Color(UIColor.systemGray3))
            .actionSheet(isPresented: $showIEXAlert) {
                ActionSheet(
                    title: Text("IEX Cloud"),
                    message: Text("Open iexcloud.io in Safari?"),
                    buttons: [ .cancel(), .default(Text("Yes")) { print("open safari") } ] )
            }
        }
        .navigationBarTitle(Text("\(stock.name ?? "error")"), displayMode: .inline)
        .navigationBarItems(leading:
            HStack {
                Button( action: { print("expand/minimize") } ) { Image(systemName: "arrow.up.left.and.arrow.down.right") }
                Button("Download Data") { self.model.getHistoricalData(from: self.stock.symbol!) }
            }
            ,trailing: HStack { Button("Show popover") { self.showFilterPopover = true }.popover(isPresented: self.$showFilterPopover) { FilterPopoverView() }
                Button( action: { print("favorite") } ) { Image(systemName: "star") }
            }
            )
            .padding(.all, 20)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
