//
//  SidebarModel.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/11/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import Combine
import CoreData
import UIKit

class SidebarModel: ObservableObject {
    @Published var logoData: Data?
    @Published var histData: HistoricalPrices = []
    var cancellationToken: AnyCancellable?
    
    func getLogo(from symbol: String) {
        print("requesting logo... for \(symbol)")
        print("https://storage.googleapis.com/iex/api/logos/\(symbol.uppercased()).png")
        cancellationToken = URLSession.shared.dataTaskPublisher(for: URL(string: "https://storage.googleapis.com/iex/api/logos/\(symbol.uppercased()).png")!)
            .map{$0.data}
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.logoData, on: self)
    }
    
//    func getHistoricalData(from symbol: String) {
//        print("symbol: \(symbol)")
//        self.cancellationToken = IEXMachine.requestHistorical(from: symbol)
//            .mapError({ (error) -> Error in
//                print("ERROR: \(error)")
//                return error
//            })
////            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { _ in },
//                receiveValue: {
//                    self.histData = $0
//                    self.insertDataIntoCoreData(dataPoints: $0, symbol: symbol)
//                    // TODO: get logo if stock does not already have one
//                    print("~\(self.histData.count / 253) years of \(symbol) data")
//                }
//            )
//        }
    
//    func insertDataIntoCoreData(dataPoints: HistoricalPrices, symbol: String) {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        let container = appDelegate?.persistentContainer
//        let taskContext = container!.newBackgroundContext()
//
//        //        if settings.isPro {
//        //            taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
//        //        }
//        //        else {
//        //            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy //NSMergeByPropertyStoreTrumpMergePolicy
//        //        }
//        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy //NSMergeByPropertyStoreTrumpMergePolicy
//
//        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
//        let filter = symbol
//        let predicate = NSPredicate(format: "symbol == %@", filter)
//        fetchRequest.predicate = predicate
//
//        let foundStock = try? taskContext.fetch(fetchRequest)
//        if let f = foundStock {
//            if f.count > 1 {
//                fatalError("too many stocks with the same symbol in core data")
//            }
//            else {
//                taskContext.perform {
////                    print(dataPoints)
//                    for d in dataPoints {
//                        let day = Day(context: taskContext)
//                        day.id = "\(f[0].symbol!)+\(d.date)"
//                        day.change = d.change
//                        day.changeOverTime = d.changeOverTime
//                        day.changePercent = d.changePercent
//                        day.close = d.close
//                        day.date = d.date
//                        //day.label
//                        //day.uClose
//                        day.stock = f.first
//                        day.volume = Int64(d.volume)
////                            self.stockData.append(day)
//                    }
//                    do {
//                        try taskContext.save()
//                        print("saved to core data")
//                        // TODO: update chart from here
//                    }
//                    catch {
//                        fatalError("unable to save batch")
//                    }
//                    taskContext.reset()
//        //                    self.shouldUpdateWithNonCoreData = true
//                }
//            }
//        }
//        else {
//            fatalError("no stock found with that symbol")
//        }
//    }
    
}
