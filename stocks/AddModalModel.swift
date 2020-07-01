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
    @Published var quotes: [QuoteResponse] = []
    @Published var searchResults: [SearchResponse] = []
    
    var cancellationToken: AnyCancellable?
    
    func getQuote(from symbol: String) {
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
                self.quotes.append($0.self)
        })
    }
    
}
//    @Published var isLoading: Bool = false
//    @Published var quoteData: QuoteResponse!
//    @Published var searchData: SearchResponse!
//
//    var searchTerm = ""
//
//    private let searchTappedSubject = PassthroughSubject<Void, Error>()
//    private var disposeBag = Set<AnyCancellable>()
//
//    init() {
//        searchTappedSubject
//    }
    
//    func getQuoteData(searchTerm: String) -> AnyPublisher<QuoteResponse, Error> {
//        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: createQuoteURL(symbol: searchTerm)))
//            .map { $0.data }
//            .mapError { $0 as Error }
//            .decode(type: QuoteResponse.self, decoder: JSONDecoder)
//    }
    
//}

//class AddModalModel: ObservableObject {
//    @Published var quote: QuoteResponse?
//    var cancellationToken: AnyCancellable?
//
//    init(symbol: String) {
//        getQuote(from: symbol)
//    }
//
//    func getQuote(from symbol: String) {
//        cancellationToken = IEXMachine.requestQuote(from: symbol)
//        .mapError({ (error) -> Error in
//            print(error)
//            return error
//        })
//        .sink(receiveCompletion: { _ in },
//              receiveValue: {
//                self.quote = $0.self
//        })
//    }
//}
//
//class QuoteDataProvider: ObservableObject {
//    let didChange = PassthroughSubject<QuoteDataProvider, Never>()
//
//    var quoteData: QuoteResponse! {
//        didSet {
//            didChange.send(self)
//        }
//    }
//}
