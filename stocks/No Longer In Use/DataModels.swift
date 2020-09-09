//
//  DataModels.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/27/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//class StockListModel: ObservableObject {
//    @Published var dataSource: StockRowModel?
//
//    let symbol: String
//    private let webService: WebService
//    private var disposables = Set<AnyCancellable>()
//
//    init(symbol: String, webService: WebService) {
//        self.symbol = symbol
//        self.webService = webService
//    }
    
//    func refresh() {
//        webService
//            .getQuoteData(for: symbol)
//            .map(StockRowModel.init)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] value in
//                guard let self = self else { return }
//                switch value {
//                case .failure:
//                    self.dataSource = nil
//                case .finished:
//                    break
//                }
//                }, receiveValue: { [weak self] stocks in
//                    guard let self = self else { return }
//                    self.dataSource = stocks
//            })
//            .store(in: &disposables)
//    }
//}

//struct StockRowModel{
//    private let item: QuoteResponse
//
//    var symbol: String {
//        return item.symbol
//    }
//    var latestPrice: String {
//        return String(format: "%.2f", item.latestPrice)
//    }
//
//    init(item: QuoteResponse) {
//        self.item = item
//    }
//}
