//
//  HistoricalData.swift
//  stocks
//
//  Created by Alexander Rohrig on 11/15/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class HistoricalData: ObservableObject {
    
    @Published var prices = [Double]()
    
    var cancellable : Set<AnyCancellable> = Set()
    
    private let api = "https://cloud.iexapis.com/"
    private let sandboxAPI = "https://sandbox.iexapis.com/"
    private let version = "stable/"
    private let token = "?token="
    
    
    init(fromSymbol: String) {
        fetchHistoricalData(fromSymbol: fromSymbol)
    }
    
    func fetchHistoricalData(fromSymbol: String) {
        URLSession.shared.dataTaskPublisher(for: createHistoricalURL(symbol: fromSymbol)).map { output in
            return output.data
        }
        .decode(type: HistoricalPrices.self, decoder: JSONDecoder())
        .sink(receiveCompletion: {_ in
            print("completed")
        }, receiveValue: { value in
            var prices = [Double]()
        })
    }
    
    func createHistoricalURL(symbol: String) -> URL {
        
        // range options
        // max, 5y, 2y, 1yr, ytd
        // more than 5 with paid only subscription
        
        // 10 for adjusted + unadjusted
        // 2 for adjusted (chartCloseOnly)
        
        let endpoint = "stock/" + symbol + "/chart/max"
        
        let chartCloseOnlyParam = "?chartCloseOnly=true&token="
        
        print(sandboxAPI + version + endpoint + chartCloseOnlyParam + sandboxToken)
        
        return URL(string: sandboxAPI + version + endpoint + chartCloseOnlyParam + sandboxToken)!
    }
    
}

struct HistoricalPrice: Codable {
    let date: String
    let close: Double
    let volume: Int
    let change, changePercent, changeOverTime: Double
}

typealias HistoricalPrices = [HistoricalPrice]
