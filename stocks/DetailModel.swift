//
//  DetailModel.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/29/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import Combine
import CoreData
import UIKit
import SwiftUI

struct Workaround {
    static var historicalDataAsDayArray: [Day] = []
}

class DetailModel: ObservableObject {
    
    @Published var historicalData: HistoricalPrices = []
//    @Published var historicalDataAsDayArray: [Day] = []
//    @Published var stockShouldUpdateData = false
//    @Published var shouldUpdateWithNonCoreData = false
    
    // TODO: HistoricalPrices <-> [Day]
    
//    let stock: Stock
    var cancellationToken: AnyCancellable?
    
//    init(stock: Stock) {
//        self.stock = stock
//    }
    
    func fetchHistoricalData(stock: Stock) {
        print("\(stock.symbol)...")
        cancellationToken = IEXMachine.requestHistorical(from: stock.symbol!)
        .mapError({ (error) -> Error in
            print(error)
            return error
        })
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.historicalData = $0
//            self.historicalDataAsDayArray = self.historicalPricesToDays(input: $0, stock: stock)
//            self.insertDataIntoCoreData(dataPoints: $0, symbol: stock.symbol!)
            print("received data ☺️")
        })
    }
    
//    func historicalPricesToDays(input: HistoricalPrices, stock: Stock) -> [Day] {
//        var days: [Day] = []
//        for h in input {
//            let d = Day()
//            d.date = h.date
//            d.id = "\(stock.symbol!)+\(h.date)"
//            d.close = h.close
//            d.volume = Int64(h.volume)
//            days.append(d)
//        }
//        return days
//    }
    
//    private(set) var persistentContainer: NSPersistentContainer
//    var cancellationToken: AnyCancellable?
    
//    func getHistoricalData(from symbol: String) {
//        print("symbol: \(symbol)")
//        cancellationToken = IEXMachine.requestHistorical(from: symbol)
//        .mapError({ (error) -> Error in
//            print(error)
//            return error
//        })
//        .receive(on: RunLoop.main)
//        .sink(receiveCompletion: { _ in },
//              receiveValue: {
//                self.historicalData = $0
//                self.insertDataIntoCoreData(dataPoints: $0, symbol: symbol)
//                // TODO: get logo if stock does not already have one
//                print("~\(self.historicalData.count / 253) years of \(symbol) data")
//                print(self.stockData)
//        })
//    }
//    
    func insertDataIntoCoreData(dataPoints: HistoricalPrices, symbol: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let container = appDelegate?.persistentContainer
        let taskContext = container!.newBackgroundContext()
        
//        if settings.isPro {
//            taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
//        }
//        else {
//            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy //NSMergeByPropertyStoreTrumpMergePolicy
//        }
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy //NSMergeByPropertyStoreTrumpMergePolicy
        
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        let filter = symbol
        let predicate = NSPredicate(format: "symbol == %@", filter)
        fetchRequest.predicate = predicate
        
        let foundStock = try? taskContext.fetch(fetchRequest)
        if let f = foundStock {
            if f.count > 1 {
                fatalError("too many stocks with the same symbol in core data")
            }
            else {
                taskContext.perform {
//                    print(dataPoints)
                    for d in dataPoints {
                        let day = Day(context: taskContext)
                        day.id = "\(f[0].symbol!)+\(d.date)"
                        day.change = d.change
                        day.changeOverTime = d.changeOverTime
                        day.changePercent = d.changePercent
                        day.close = d.close
                        day.date = d.date
                        //day.label
                        //day.uClose
                        day.stock = f.first
                        day.volume = Int64(d.volume)
//                        DispatchQueue.main.async {
//                            Workaround.historicalDataAsDayArray.append(day)
//                        }
                    }
                    do {
                        try taskContext.save()
                        print("saved to core data")
                        // TODO: update chart from here
                    }
                    catch {
                        fatalError("unable to save batch")
                    }
                    taskContext.reset()
//                    self.shouldUpdateWithNonCoreData = true
                }
            }
        }
        else {
            fatalError("no stock found with that symbol")
        }
    }
}
