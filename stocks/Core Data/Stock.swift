//
//  Stock.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/25/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

extension Stock {
    
    func getCoreDataStockFrom(symbol: String) {
        
    }
    
    static func create(in managedObjectContext: NSManagedObjectContext, with name: String, symbol: String, latestPrice: Double, image: Data?) {
        let newStock = self.init(context: managedObjectContext)
        newStock.logo = image
        newStock.name = name
        newStock.symbol = symbol
        newStock.lastViewed = Date()
        newStock.id = UUID()
        newStock.isFavorite = false
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error, \(nserror.code) \(nserror), \(nserror.userInfo)")
        }
    }
    
    static func create(in managedObjectContext: NSManagedObjectContext){
        let newStock = self.init(context: managedObjectContext)
        newStock.lastViewed = Date()
        newStock.id = UUID()
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension Collection where Element == Stock, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }
 
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

struct Stock_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
