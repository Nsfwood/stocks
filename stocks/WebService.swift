//
//  WebService.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/25/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import Combine

private let api = "https://cloud.iexapis.com/"
private let sandboxAPI = "https://sandbox.iexapis.com/"
private let version = "stable/"
private let token = "?token="

// https://sandbox.iexapis.com/stable/stock/IBM/quote?token=YOUR_TEST_TOKEN_HERE

// MARK: Getting the data

enum IEXMachine {
    static let apiMachine = APIMachine()
    
}

extension IEXMachine {
    
    static func requestCEOInfo(from symbol: String) -> AnyPublisher<CEOCompensationResponse, Error> {
        let request = URLRequest(url: createCEOURL(from: symbol))
        
        print("requestiny CEO data... weight: 20")
        
        return apiMachine.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func requestQuote(from symbol: String) -> AnyPublisher<QuoteResponse, Error> {
        let request = URLRequest(url: createQuoteURL(symbol: symbol))
        
        print("requesting quote data... weight: 1")
        
        return apiMachine.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func requestHistorical(from symbol: String) -> AnyPublisher<HistoricalPrices, Error> {
        let request = URLRequest(url: createHistoricalURL(symbol: symbol))
        print("requesting historical data... weight: 2")
        return apiMachine.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

// MARK: General API machine
struct APIMachine {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

//class WebService {
//    private let session: URLSession = URLSession.shared
//
//    func getHistoricalData(for symbol: String) -> AnyPublisher<HistoricalPricesResponse, WebServiceError> {
//        return getFromWebService(at: createHistoricalURL(symbol: symbol))
//    }
//
//    func getQuoteData(for symbol: String) -> AnyPublisher<QuoteResponse, WebServiceError> {
//        return getFromWebService(at: createQuoteURL(symbol: symbol))
//    }
//
//    func getFromWebService<T>(at url: URL) -> AnyPublisher<T, WebServiceError> where T: Decodable {
//        return session.dataTaskPublisher(for: URLRequest(url: url))
//        .mapError { error in
//          .network(description: error.localizedDescription)
//        }
//        .flatMap(maxPublishers: .max(1)) { pair in
//          decode(pair.data)
//        }
//        .eraseToAnyPublisher()
//    }
//}

// MARK: Parsing data

//func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, WebServiceError> {
//  let decoder = JSONDecoder()
//  decoder.dateDecodingStrategy = .secondsSince1970
//
//  return Just(data)
//    .decode(type: T.self, decoder: decoder)
//    .mapError { error in
//      .parsing(description: error.localizedDescription)
//    }
//    .eraseToAnyPublisher()
//}

// MARK: URLS (iexcloud.io)

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

func createQuoteURL(symbol: String) -> URL {
    //GET /stock/{symbol}/quote/{field}
    let endpoint = "stock/" + symbol + "/quote"
    
    return URL(string: sandboxAPI + version + endpoint + token + sandboxToken)!
}

func createPriceURL(symbol: String) -> URL {
    let endpoint = "stock/" + symbol + "/price"
    
    return URL(string: sandboxAPI + version + endpoint + token + sandboxToken)!
}

func createLogoURL(symbol: String) -> URL {
    let endpoint = "stock/" + symbol + "/logo"
    
    return URL(string: sandboxAPI + version + endpoint + token + sandboxToken)!
}

func createSearchURL(from fragment: String) -> URL {
    let endpoint = "search/"
    
    return URL(string: sandboxAPI + version + endpoint + token + sandboxToken)!
}

func createCEOURL(from symbol: String) -> URL {
    let endpoint = "stock/\(symbol)/ceo-compensation"
    
    return URL(string: sandboxAPI + version + endpoint + token + sandboxToken)!
}
