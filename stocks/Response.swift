//
//  Response.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/27/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation

enum WebServiceError: Error {
    case parsing(description: String)
    case network(description: String)
}

struct HistoricalPrice: Codable {
    let date: String
    let close: Double
    let volume: Int
    let change, changePercent, changeOverTime: Double
}

typealias HistoricalPrices = [HistoricalPrice]

struct QuoteResponse: Codable {
    let symbol: String
    let companyName: String
    let latestPrice: Double
//    let latestVolume: Int
    let latestTime: String
    let change: Double?
    let changePercent: Double?
}

// weight: 20
struct CEOCompensationResponse: Codable {
    let symbol: String
    let name: String
    let companyName: String
    let location: String
    let salary: Int
    let bonus: Int
    let stockAwards: Int
    let optionAwards: Int
    let nonEquityIncentives: Int
    let pensionAndDeferred: Int
    let otherComp: Int
    let total: Int
    let year: String
}

// GET /stock/{symbol}/ceo-compensation
//{
//    "symbol": "AVGO",
//    "name": "Hock E. Tan",
//    "companyName": "Broadcom Inc.",
//    "location": "Singapore, Asia",
//    "salary": 1100000,
//    "bonus": 0,
//    "stockAwards": 98322843,
//    "optionAwards": 0,
//    "nonEquityIncentives": 3712500,
//    "pensionAndDeferred": 0,
//    "otherComp": 75820,
//    "total": 103211163,
//    "year": "2017"
//}

// {"url":"o/io/.ggs7ileon/cmpoogplgelhd3i:/a.tpuags/polaxsc.pshD-gI/tSeroot"}

// https://storage.googleapis.com/iex/api/logos/TWTR.png

struct LogoResponse: Codable {
    let url: URL
}

// premium only
struct SearchResponse: Codable {
    let list: [Item]
    
    struct Item: Codable {
        let symbol: String
        let securityName: String
        let securityType: String
        let region: String
        let exchange: String
    }
}
