//
//  ChartViewController.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/1/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Combine

enum ChartStatus {
    case dataIsMoreThanOneDayOld
    case dataDoesNotExist
    case notEnoughDataToBuildGraph
    case dataLooksGood
    case notComputableWithCurrentFilter
}

class ChartModel: ObservableObject {
//    var cancellationToken: AnyCancellable?
//    @Published var historicalData: HistoricalPrices = []

//    func getHistoricalData(from symbol: String) {
//        print("symbol: \(symbol)")
//        self.cancellationToken = IEXMachine.requestHistorical(from: symbol)
//            .mapError({ (error) -> Error in
//                print("ERROR: \(error)")
//                return error
//            })
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: {
//    //                    self.historicalData = $0
////                    self.insertDataIntoCoreData(dataPoints: $0, symbol: symbol)
//                    // TODO: get logo if stock does not already have one
//    //                    print("~\(self.historicalData.count / 253) years of \(symbol) data")
//                    self.historicalData = $0
//                    print("give chart new data")
//            })
//        }
}

struct ChartViewController: UIViewControllerRepresentable {
    
//    @Binding var shouldUpdateChart: Bool
//    @Binding var indexes: [Int]?
    class RandomClass { }
    let x = RandomClass()
//    @ObservedObject var model = ChartModel()
    @EnvironmentObject var settings: SettingsStorage
    var stockToFetchDataFor: Stock
    typealias UIViewControllerType = UIViewController
    typealias chartData = (x: Int, y: Double)

    func makeUIViewController(context: Context) -> UIViewController {
        
        let viewController = UIViewController()
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: viewController.view.frame.height))
        
        print("bounds of chart: \(chart.bounds)")
        
        makeChart(chart: chart)
        
        chart.delegate = context.coordinator
        viewController.view.addSubview(chart)
        chart.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chart.sizeToFit()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("chart view updated")
        // date format: jul 1 2020 -> 2020182
//        print("\(settings.xRangeStart.inAlexanderDateFormat), \(settings.yRangeStart) - INCLUDE ALL YEARS: \(settings.includeAllYears)")
//        print("\(settings.xRangeEnd.inAlexanderDateFormat), \(settings.yRangeEnd)")
        
//        print(model.historicalData)
        
//        if model.historicalData.isEmpty {
//            print("model data is empty")
//        }
        
        let chart = uiViewController.view.subviews[0] as! Chart
        chart.removeAllSeries()
        
        if let stockData = stockToFetchDataFor.days?.allObjects as? [Day] {
            if stockData.count > 2 {

                if settings.xRangeStart.getDayOfYear() >= settings.xRangeEnd.getDayOfYear() {
                    chart.add(graphDataByIteratingThroughDataWithForLoop(usingData: stockData))
                }
                else {
                    chart.add(graphDataByIteratingThroughDataWithFilters(usingData: stockData))
                }

                let colors = [UIColor.systemBlue, UIColor.systemRed, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemPink, UIColor.systemTeal, UIColor.systemYellow]
                var colorCount = 0

                for c in chart.series {
                    c.area = settings.showGraphArea
                    c.color = colors[colorCount]
                    c.line = true
                    colorCount += 1
                }
                
                chart.showXLabelsAndGrid = false

                if let s = Double(settings.yRangeStart), let e = Double(settings.yRangeEnd) {
                    chart.minY = s
                    chart.maxY = e
                }
                else {
                    chart.minY = nil
                    chart.maxY = nil
                }
            }
//            else if !Workaround.historicalDataAsDayArray.isEmpty {
//                print("using data from model")
//                chart.add(graphDataByIteratingThroughDataWithFilters(usingData: Workaround.historicalDataAsDayArray))
//
//            }
            else {
                // TODO: add label subview
                print("No data available for \(stockToFetchDataFor.symbol)")
                
//                let appDelegate = UIApplication.shared.delegate as? AppDelegate
//                let container = appDelegate?.persistentContainer
//                let taskContext = container!.newBackgroundContext()
//                let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
//                let filter = stockToFetchDataFor.symbol!
//                let predicate = NSPredicate(format: "symbol == %@", filter)
//                fetchRequest.predicate = predicate
//                let foundStock = try? taskContext.fetch(fetchRequest)
//                
//                if let a = foundStock {
//                    if let b = a.first {
//                        if let c = b.days {
//                            if let d = c.allObjects as? [Day] {
//                                if !d.isEmpty {
//                                    print(d)
//                                    chart.add(graphDataByIteratingThroughDataWithForLoop(usingData: d))
//                                }
//                            }
//                        }
//                    }
//                }
            }
        }
    }
    
    func makeCoordinator() -> ChartViewController.Coordinator {
        return Coordinator(self)
    }
    
    func graphDataByIteratingThroughData(usingData: [Day]) -> [ChartSeries] {
        var arrayOfChartData = [chartData]()
        var arrayOfChartSeries = [ChartSeries]()
        var count: Int = 0
        var chartCount: Int = 0
        var histCount: Int = 0
        let stockDataSorted = usingData.sorted(by: { $0.date! < $1.date! })
        var goal = stockDataSorted.count
        let dF = DateFormatter()
        
        dF.dateFormat = "yyyy-MM-dd"
        arrayOfChartSeries.removeAll()
        
        var yearToCompare = dF.date(from: stockDataSorted[0].date!)
        
        while goal != 0 {
            let dateToCompare = dF.date(from: stockDataSorted[histCount].date!)!
//            print("\(goal) items \(chartCount) line \(String(describing: stockDataSorted[histCount].date)) date \(dateToCompare) date")

            if yearToCompare!.isEqual(to: dateToCompare, toGranularity: .year) {
                arrayOfChartData.append((x: dateToCompare.getDayOfYear(), y: stockDataSorted[histCount].close))
                count += 1
                histCount += 1
                goal -= 1
            }
            else {
                arrayOfChartSeries.append(ChartSeries(data: arrayOfChartData))
                arrayOfChartData.removeAll()
                chartCount += 1
                count = 0
                yearToCompare = dF.date(from: stockDataSorted[histCount].date!)
            }

            if chartCount > 30 {
                break
            }

        }
        
        return arrayOfChartSeries
    }
    
    func graphDataByIteratingThroughDataWithForLoop(usingData: [Day]) -> [ChartSeries] {
        
//        print("charting data...")
        
        var arrayOfLineData = [chartData]()
        var arrayOfLines = [ChartSeries]()
        
        let sortedData = usingData.sorted(by: { $0.date! < $1.date! })
        
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd"
        
        let startingYear = dF.date(from: sortedData.first!.date!)
        
        var listOfYears: [Int] = []
        let first = dF.date(from: sortedData[0].date!)
        listOfYears.append(first!.yearAsInt)
        // encounter year
        // check if that year is in year array
        // if it is add to chart series array in same index
        // if it is not add that year to year array
        
        for dataEntry in sortedData {
            let asDate = dF.date(from: dataEntry.date!)
            if !listOfYears.contains(asDate!.yearAsInt) {
                listOfYears.append(asDate!.yearAsInt)
                arrayOfLines.append(ChartSeries(data: arrayOfLineData))
                arrayOfLineData.removeAll()
            }
            arrayOfLineData.append(chartData(x: asDate!.getDayOfYear(), y: dataEntry.close))
//            print("year of data: \(asDate!.yearAsInt) day: \(asDate!.getDayOfYear()) close: \(dataEntry.close)")
        }
        arrayOfLines.append(ChartSeries(data: arrayOfLineData))
        
//        print(arrayOfLines.count)
        
//        arrayOfLines.append(ChartSeries(data: arrayOfLineData))
        
//        let xMin = settings.xRangeStart.inAlexanderDateFormat
//        let xMax = settings.xRangeEnd.inAlexanderDateFormat
//
//        let xMinWithoutYear = (xMin % 1000)
//        let xMaxWithoutYear = (xMax % 1000)
//
//        let xMinWithAdjustedYear = xMinWithoutYear + (startingYear!.yearAsInt * 1000)
//        let xMaxWithAdjustedYear = xMaxWithoutYear + (Date().yearAsInt * 1000)
//
//        print("\(xMin) -> \(xMax)")
//        print("\(xMinWithoutYear) -> \(xMaxWithoutYear)")
//        print("\(xMinWithAdjustedYear) -> \(xMaxWithAdjustedYear)")
//
//        var dayCounter = xMinWithAdjustedYear
//        var dataCounter = 0
//        var dataPointsCounter = 0
//
//        if xMin < xMax {
//            print("data starts in \(startingYear!.yearAsInt)")
//
//            while dayCounter <= xMaxWithAdjustedYear {
//
//            }
//
//        }
//
//        print("chart will have \(dataPointsCounter) data points")
        
        return arrayOfLines
    }
    
    func graphDataByIteratingThroughDataWithFilters(usingData: [Day]) -> [ChartSeries] {
        
//        print("charting data with filters...")
        
            let xMin = settings.xRangeStart.inAlexanderDateFormat
            let xMax = settings.xRangeEnd.inAlexanderDateFormat
    
            let xMinWithoutYear = (xMin % 1000)
            let xMaxWithoutYear = (xMax % 1000)
    
//            let xMinWithAdjustedYear = xMinWithoutYear + (startingYear!.yearAsInt * 1000)
//            let xMaxWithAdjustedYear = xMaxWithoutYear + (Date().yearAsInt * 1000)
    
            print("\(xMin) -> \(xMax)")
            print("\(xMinWithoutYear) -> \(xMaxWithoutYear)")
//            print("\(xMinWithAdjustedYear) -> \(xMaxWithAdjustedYear)")
        
            var arrayOfLineData = [chartData]()
            var arrayOfLines = [ChartSeries]()
            
            let sortedData = usingData.sorted(by: { $0.date! < $1.date! })
            
            let dF = DateFormatter()
            dF.dateFormat = "yyyy-MM-dd"
            
            let startingYear = dF.date(from: sortedData.first!.date!)
        
        if startingYear! < Date() {
            print("chart out of date")
        }
            
            var listOfYears: [Int] = []
            let first = dF.date(from: sortedData[0].date!)
            listOfYears.append(first!.yearAsInt)
            
            for dataEntry in sortedData {
                let asDate = dF.date(from: dataEntry.date!)
                
                if asDate!.getDayOfYear() >= xMinWithoutYear && asDate!.getDayOfYear() <= xMaxWithoutYear {
                    if !listOfYears.contains(asDate!.yearAsInt) {
                        listOfYears.append(asDate!.yearAsInt)
                        arrayOfLines.append(ChartSeries(data: arrayOfLineData))
                        arrayOfLineData.removeAll()
                    }
                    arrayOfLineData.append(chartData(x: asDate!.getDayOfYear(), y: dataEntry.close))
                    print("year of data: \(asDate!.yearAsInt) day: \(asDate!.getDayOfYear()) close: \(dataEntry.close)")
                }
            }
            
            return arrayOfLines
        }
    
    func graphDataByIteratingThroughDates(usingData: [Day]) -> [ChartSeries] {
        var arrayOfChartData = [chartData]()
        var arrayOfChartSeries = [ChartSeries]()
        var count: Int = 0
        var chartCount: Int = 0
        var histCount: Int = 0
        let stockDataSorted = usingData.sorted(by: { $0.date! < $1.date! })
        var goal = stockDataSorted.count
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd"
        let yearToCompare = dF.date(from: stockDataSorted[0].date!)
        let xStart = settings.xRangeStart.inAlexanderDateFormat
        let xEnd = settings.xRangeEnd.inAlexanderDateFormat
        var shouldFilterX = false
        var xAxisArray: [Double] = []
        var dateCounter = (yearToCompare?.inAlexanderDateFormat)!
        if settings.startChartsAtJan1 {
            print("chart will start at jan 1")
            dateCounter = (yearToCompare?.yearAsInt)! * 1000
        }
        if xEnd > xStart && xEnd - xStart > 1 {
            print("x filter is on, chart will start at \(xStart % 1000)")
            dateCounter = xStart
            shouldFilterX = true
        }
        while dateCounter != Date().inAlexanderDateFormat {
            let dateToCompare = dF.date(from: stockDataSorted[histCount].date!)!.inAlexanderDateFormat
//                    print(dateCounter)
//                    xAxisArray.append(Double(dateCounter % 1000))
            if shouldFilterX && (dateToCompare % 1000) > (dateCounter % 1000) {
                print("reached end of x filter")
                arrayOfChartSeries.append(ChartSeries(data: arrayOfChartData))
                arrayOfChartData.removeAll()
                chartCount += 1
                dateCounter += 1
            }
            else if shouldFilterX {
                print("found match in data with x filter")
                arrayOfChartData.append((x: dateToCompare % 1000,y: stockDataSorted[histCount].close))
                histCount += 1
            }
            else {
                if dateToCompare == dateCounter {
                    print("found match in data \(dateCounter)")
                    arrayOfChartData.append((x: dateToCompare % 1000,y: stockDataSorted[histCount].close))
                    histCount += 1
                }
                if (dateCounter % 1000) == 366 {
                    print("reached end of year, leap included")
                    dateCounter += 635
                    arrayOfChartSeries.append(ChartSeries(data: arrayOfChartData))
                    arrayOfChartData.removeAll()
                    chartCount += 1
                }
                else {
                    dateCounter += 1
                }
            }
        }
        
        return arrayOfChartSeries
    }
    
    func makeChart(chart: Chart) {
        
        print("making chart...")
        
        // jul 1 2020 -> 2020182, jan 1 2020 -> 2020001
        
        if let stockData = stockToFetchDataFor.days?.allObjects as? [Day] {
            
            // TODO: add if data is out of date
            if stockData.isEmpty {
                print("app needs to download data")
//                model.getHistoricalData(from: stockToFetchDataFor.symbol!)
            }
            else if stockData.last?.date?.toDate.getDayOfYear() != Date().getDayOfYear() {
                print("stock data out of date")
            }
            else {
                print("making chart...")
                
                var arrayOfChartLines: [ChartSeries] = []
                
                chart.hideHighlightLineOnTouchEnd = true
                chart.bottomInset = 0
                chart.add(arrayOfChartLines)
                chart.showYLabelsAndGrid = true
                chart.showXLabelsAndGrid = false
            }
        }
    }
}
//
//extension ChartViewController {
//
//    func getHistoricalData(from symbol: String) {
////        var cancellationToken: AnyCancellable?
//        print("symbol: \(symbol)")
//        self.cancellationToken = IEXMachine.requestHistorical(from: symbol)
//            .mapError({ (error) -> Error in
//                print("ERROR: \(error)")
//                return error
//            })
////            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: {
////                    self.historicalData = $0
////                    self.insertDataIntoCoreData(dataPoints: $0, symbol: symbol)
//                    // TODO: get logo if stock does not already have one
////                    print("~\(self.historicalData.count / 253) years of \(symbol) data")
//                    print($0)
//            })
//        }
//
//        func insertDataIntoCoreData(dataPoints: HistoricalPrices, symbol: String) {
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            let container = appDelegate?.persistentContainer
//            let taskContext = container!.newBackgroundContext()
//
//    //        if settings.isPro {
//    //            taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
//    //        }
//    //        else {
//    //            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy //NSMergeByPropertyStoreTrumpMergePolicy
//    //        }
//            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy //NSMergeByPropertyStoreTrumpMergePolicy
//
//            let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
//            let filter = symbol
//            let predicate = NSPredicate(format: "symbol == %@", filter)
//            fetchRequest.predicate = predicate
//
//            let foundStock = try? taskContext.fetch(fetchRequest)
//            if let f = foundStock {
//                if f.count > 1 {
//                    fatalError("too many stocks with the same symbol in core data")
//                }
//                else {
//                    taskContext.perform {
//    //                    print(dataPoints)
//                        for d in dataPoints {
//                            let day = Day(context: taskContext)
//                            day.id = "\(f[0].symbol!)+\(d.date)"
//                            day.change = d.change
//                            day.changeOverTime = d.changeOverTime
//                            day.changePercent = d.changePercent
//                            day.close = d.close
//                            day.date = d.date
//                            //day.label
//                            //day.uClose
//                            day.stock = f.first
//                            day.volume = Int64(d.volume)
////                            self.stockData.append(day)
//                        }
//                        do {
//                            try taskContext.save()
//                            print("saved to core data")
//                            // TODO: update chart from here
//                        }
//                        catch {
//                            fatalError("unable to save batch")
//                        }
//                        taskContext.reset()
//    //                    self.shouldUpdateWithNonCoreData = true
//                    }
//                }
//            }
//            else {
//                fatalError("no stock found with that symbol")
//            }
//        }
//}

extension ChartViewController {
    class Coordinator: NSObject, ChartDelegate {
        var parent: ChartViewController
        
        init(_ parent: ChartViewController) {
            self.parent = parent
        }
        
        // chart delegate
        func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
//            print(indexes)
            print("(\(x), \(left))")
        }
        
        func didFinishTouchingChart(_ chart: Chart) {
            print("finish")
        }

        func didEndTouchingChart(_ chart: Chart) {
            print("end")
        }
        
    }
}

struct ChartViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChartViewController(stockToFetchDataFor: createPreviewStock()).modifier(SystemServices())
    }
}
