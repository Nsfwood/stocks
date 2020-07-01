//
//  AddModalView.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/27/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct AddModalView: View {
    @State var hasSearchedForStock = false
    @State var hasFoundValidStock = false
    @State private var searchText = ""
    @State var oldSearchTextToPreventDuplicateSearches = ""
//    @State private var results: SearchResponse? = nil
//    @ObservedObject var model = AddModalModel(symbol: "NKLA")
//    @ObservedObject var quoteData: QuoteDataProvider
    @ObservedObject var model = AddModalModel()
    @Environment(\.presentationMode) var presentationMode
    
    var receivedQuote: QuoteResponse?
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    var body: some View {
        
        VStack {
            Text("Add Stock")
                .font(.title)
            HStack {
                Button("Cancel") {
                    print("cancelled")
                    self.presentationMode.wrappedValue.dismiss()
                }
                TextField(
                    "Enter stock symbol",
                    text: $searchText,
                    onEditingChanged: { _ in print("edited") },
                    onCommit: {
                        print("committed")
                        if self.searchText != self.oldSearchTextToPreventDuplicateSearches {
                            self.oldSearchTextToPreventDuplicateSearches = self.searchText
                            print("searching...")
                            self.model.getQuote(from: self.searchText)
                        }
                    }
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(
                    action: {
                        print("searched")
                        if self.searchText != self.oldSearchTextToPreventDuplicateSearches {
                            self.oldSearchTextToPreventDuplicateSearches = self.searchText
                            print("searching...")
                            self.model.getQuote(from: self.searchText)
                        }
                    }
                ) {
                    Image(systemName: "magnifyingglass")
                }
            }
            Text("")
                .foregroundColor(Color(UIColor.systemGray3))
            Text("US exchanges: NYS, NAS, PSE, BATS, ASE \nInternational exchanges: TSE, LON, KRX, MEX, BOM, TSX, TAE, PAR, ETR, AMS, BRU, DUB, LIS, ADS")
                .foregroundColor(Color(UIColor.systemGray3))
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Name: \(model.quotes.first?.companyName ?? "___")")
                    Text("Updated: \(model.quotes.first?.latestTime ?? "___")")
                }.padding(.trailing, 10)
                VStack(alignment: .trailing) {
                    Text(String(format: "Latest Price: $%.2f", model.quotes.first?.latestPrice ?? 0.0))
                    Text(String(format: "Change: %.2f%%", (model.quotes.first?.changePercent ?? 0.0) * 100))
                }.padding(.leading, 10)
            }
            Spacer()
            Text("Upgrade to Premium for search by name and fragments.")
            if model.foundValidStock {
                Button("Add \(model.quotes.first?.companyName ?? "error") to your stocks") {
                    
                    if let s = self.model.quotes.first {
                        Stock.create(in: self.viewContext, with: s.companyName, symbol: s.symbol, latestPrice: s.latestPrice)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                    .frame(minWidth: 100, idealWidth: 100, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.init(UIColor.systemBlue))
                    .cornerRadius(8)
                    .padding()
            }
        }.padding()
    }
}

struct AddModalView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return AddModalView().environment(\.managedObjectContext, context)
    }
}
