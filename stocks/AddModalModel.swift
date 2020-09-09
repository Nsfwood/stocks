//
//  AddModalModel.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/28/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import Combine

class AddModalModel: ObservableObject {
    
    @Published var foundValidStock = false
    @Published var searchForStock = false
    @Published var quotes: [QuoteResponse] = []
    @Published var searchResults: [SearchResponse] = []
    @Published var imageData: Data?
    
    var cancellationToken: AnyCancellable?
    
    func getLogo(from symbol: String) {
        print("requesting logo... for \(symbol)")
        print("https://storage.googleapis.com/iex/api/logos/\(symbol.uppercased()).png")
        cancellationToken = URLSession.shared.dataTaskPublisher(for: URL(string: "https://storage.googleapis.com/iex/api/logos/\(symbol.uppercased()).png")!)
            .map{$0.data}
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.imageData, on: self)
    }
    
    func getQuote(from symbol: String) {
        self.searchForStock = true
        print("symbol: \(symbol)")
        cancellationToken = IEXMachine.requestQuote(from: symbol)
        .mapError({ (error) -> Error in
            print(error)
            self.foundValidStock = false
            return error
        })
        .sink(receiveCompletion: { _ in },
              receiveValue: {
                self.foundValidStock = true
                self.getLogo(from: symbol)
                self.quotes.append($0.self)
        })
    }
    
}
