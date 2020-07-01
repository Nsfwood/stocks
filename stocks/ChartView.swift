//
//  ChartView.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/25/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI
import CoreData

struct ChartView: UIViewRepresentable {
    
//    @Binding var numberOfYears: Int
    
//    struct ChartSeries {
//        var year: Date
//        var close: Double
//    }
    
    init(stock: Stock) {
        stockToFetchDataFor = stock
    }
    
    var stockToFetchDataFor: Stock!
    
    typealias UIViewType = Chart
    
    func makeUIView(context: Context) -> Chart {
        let rectangle = CGRect.zero
        let chart = Chart(frame: rectangle)
        typealias chartData = (x: Int, y: Double)
        var arrayOfChartData = [chartData]()
        var arrayOfChartSeries = [ChartSeries]()
        var count: Int = 0
        var chartCount: Int = 0
        var histCount: Int = 0
        
//        var goal = sorted?.count
//        var goal = HistoricalData.count
        arrayOfChartSeries.removeAll()
//        arrayOfChartData.removeAll()
        
        // MARK: split into 5 arrays (non-premium)
//        var sortedData: [[Day]] = []
//        let start = (stockToFetchDataFor.days as! [Day])
        
//        let filterByYear = { year in stockToFetchDataFor.days?.filter { $0.date == year } }
//        (1...5).forEach { sortedData.append(filterByYear($0)) }
        
        // MARK: split by 365 entries
//        while goal != 0 {
//            print("\(goal) items \(count) down \(histCount) total \(chartCount) line \(HistoricalData[histCount].date) date")
//            if count == 364 {
//                count = 0
//                chartSeries.append(ChartSeries(data: chartDatas))
//                chartSeries[chartCount].area = true
//                chartDatas.removeAll()
//                chartCount += 1
//            }
//            chartDatas.append((x: count, y: HistoricalData[histCount].close))
//            count += 1
//            histCount += 1
//            goal -= 1
//        }
        
        // MARK: not split
//        for h in HistoricalData {
//            data.append((x: count, y: h.close))
//            count += 1
//            goal -= 1
//        }
//        print(count)
        
        // MARK: split by year (CoreData)
        // TODO: start chart at jan 1
        if let stockData = stockToFetchDataFor.days?.allObjects as? [Day] {
            if stockData.count > 10 {
                let stockDataSorted = stockData.sorted(by: { $0.date! < $1.date! })
                
                var goal = stockDataSorted.count
                let dF = DateFormatter()
                        dF.dateFormat = "yyyy-MM-dd"
                var yearToCompare = dF.date(from: stockDataSorted[0].date!)
                        while goal != 0 {

                            var dateToCompare = dF.date(from: stockDataSorted[histCount].date!)!
                            print("\(goal) items \(chartCount) line \(stockDataSorted[histCount].date) date \(dateToCompare) date")

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

                        let colors = [UIColor.systemBlue, UIColor.systemRed, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemPink, UIColor.systemTeal, UIColor.systemYellow]

//                        numberOfYears = arrayOfChartSeries.count
                        
                        var colorCount = 0
                        for c in arrayOfChartSeries.reversed() {
                            c.area = false // TODO: allow user to toggle
                            c.color = colors[colorCount]
                            c.line = true
                            colorCount += 1
                        }

                        chart.add(arrayOfChartSeries)
                        let daysInMonth = 30.4166666667
                        chart.xLabels = [1 * daysInMonth,
                                         2 * daysInMonth,
                                         3 * daysInMonth,
                                         4 * daysInMonth,
                                         5 * daysInMonth,
                                         6 * daysInMonth,
                                         7 * daysInMonth,
                                         8 * daysInMonth,
                                         9 * daysInMonth,
                                         10 * daysInMonth,
                                         11 * daysInMonth,
                                         12 * daysInMonth]
                        chart.showYLabelsAndGrid = true
                        chart.showXLabelsAndGrid = false
            }
        }
        
        // MARK: split by year (json)
//        let dF = DateFormatter()
//        dF.dateFormat = "yyyy-MM-dd"
//        var yearToCompare = dF.date(from: HistoricalData[0].date)
//        while goal != 0 {
//
//            var dateToCompare = dF.date(from: HistoricalData[histCount].date)!
////            print("\(goal) items \(chartCount) line \(HistoricalData[histCount].date) date \(dateToCompare) date")
//
//            if yearToCompare!.isEqual(to: dateToCompare, toGranularity: .year) {
//                arrayOfChartData.append((x: dateToCompare.getDayOfYear(), y: HistoricalData[histCount].uClose))
//                count += 1
//                histCount += 1
//                goal -= 1
//            }
//            else {
//                arrayOfChartSeries.append(ChartSeries(data: arrayOfChartData))
//                arrayOfChartData.removeAll()
//                chartCount += 1
//                count = 0
//                yearToCompare = dF.date(from: HistoricalData[histCount].date)
//            }
//
//            if chartCount > 30 {
//                break
//            }
//
//        }
//
//        let colors = [UIColor.systemBlue, UIColor.systemRed, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemPink, UIColor.systemTeal, UIColor.systemYellow]
//
////        var opacityLevel: CGFloat = CGFloat(1 / arrayOfChartSeries.count)
//        var colorCount = 0
//        for c in arrayOfChartSeries {
//            c.area = false // TODO: allow user to toggle
//            c.color = colors[colorCount]
//            c.line = true
//            colorCount += 1
//        }
//
////        chart.xLabels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
//        chart.add(arrayOfChartSeries)
//        chart.showYLabelsAndGrid = false
//        chart.showXLabelsAndGrid = false
        
        return chart
    }
    
    func updateUIView(_ uiView: Chart, context: Context) {
        print("update")
    }
    
}
