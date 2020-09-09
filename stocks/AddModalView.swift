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
    @EnvironmentObject var settings: SettingsStorage
    
    var receivedQuote: QuoteResponse?
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    var body: some View {
        
        VStack {
            Text(Translation.add_Title) // "Add Stock"
                .font(.title)
            HStack {
                Button(Translation.cancel_Button) { // Cancel
                    print("cancelled")
                    self.presentationMode.wrappedValue.dismiss()
                }
                TextField(
                    Translation.add_Search_Placeholder,
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
                        self.oldSearchTextToPreventDuplicateSearches = self.searchText
                        print("searching...")
                        self.model.getQuote(from: self.searchText)
                    }
                ) {
                    Image(systemName: "magnifyingglass")
                }
            }
            Text(Translation.add_Search_Exchanges_Subtitle) // Searchable exchanges: NYS, NAS, PSE, BATS, ASE"
                .foregroundColor(Color(UIColor.systemGray3))
            Divider()
            if model.foundValidStock == false && model.searchForStock == true {
                Text(Translation.add_Result_UnableToFind)
            }
            Group {
                Group { () -> AnyView in
                    if let i = self.model.imageData {
                        if let ui = UIImage(data: i) {
                            return AnyView(
                                Image(uiImage: ui)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                            )
                        }
                        else {
                            return AnyView(
                                Image("logo.missing")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .cornerRadius(8)
                            )
                        }
                    }
                    else {
                        return AnyView(Image("logo.missing").resizable().scaledToFit().frame(height: 100).cornerRadius(8))
                    }
                }
                Text("Name: \(model.quotes.first?.companyName ?? "___")\nUpdated: \(model.quotes.first?.latestTime ?? "___")\nLatest Price: \(getCurrencyFormat(from: model.quotes.first?.latestPrice ?? 0.0))\nChange: \(getPercentFormat(from: model.quotes.first?.changePercent ?? 0.0))")
            }.padding()
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("Name: \(model.quotes.first?.companyName ?? "___")")
//                    Text("Updated: \(model.quotes.first?.latestTime ?? "___")")
//                }.padding(.trailing, 10)
//                VStack(alignment: .trailing) {
//                    Text(String(format: "Latest Price: $%.2f", model.quotes.first?.latestPrice ?? 0.0))
//                    Text(String(format: "Change: %.2f%%", (model.quotes.first?.changePercent ?? 0.0) * 100))
//                }.padding(.leading, 10)
//            }.padding()
            Spacer()
            if !settings.isPro {
                Text(Translation.add_Premium_SearchByNF)
            }
            if model.foundValidStock {
                Button("Add \(model.quotes.first?.companyName ?? "error") to your stocks") {
                    
                    if let s = self.model.quotes.first {
                        Stock.create(in: self.viewContext, with: s.companyName, symbol: s.symbol, latestPrice: s.latestPrice, image: self.model.imageData)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            .buttonStyle(FilledBlueButton())
            .frame(minWidth: 100, idealWidth: 150, maxWidth: .infinity)
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
