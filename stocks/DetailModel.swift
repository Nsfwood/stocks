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

class DetailModel: ObservableObject {
    
    @Published var historicalData: HistoricalPrices = []
    
//    private(set) var persistentContainer: NSPersistentContainer
    var cancellationToken: AnyCancellable?
    
    func getHistoricalData(from symbol: String) {
        print("symbol: \(symbol)")
        cancellationToken = IEXMachine.requestHistorical(from: symbol)
        .mapError({ (error) -> Error in
            print(error)
            return error
        })
        .sink(receiveCompletion: { _ in },
              receiveValue: {
                self.historicalData = $0
                self.insertDataIntoCoreData(dataPoints: $0, symbol: symbol)
                print("~\(self.historicalData.count / 253) years of \(symbol) data")
        })
    }
    
    func insertDataIntoCoreData(dataPoints: HistoricalPrices, symbol: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let container = appDelegate?.persistentContainer
        let taskContext = container!.newBackgroundContext()
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
                    }
                    do {
                        try taskContext.save()
                        print("saved to core data")
                    }
                    catch {
                        fatalError("unable to save batch")
                    }
                    taskContext.reset()
                }
            }
        }
        else {
            fatalError("no stock found with that symbol")
        }
    }
    // TODO: save data to core data
}
