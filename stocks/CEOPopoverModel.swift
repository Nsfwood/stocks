//
//  CEOPopoverModel.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/5/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import Foundation
import Combine

class CEOPopoverModel: ObservableObject {
    @Published var ceoData: CEOCompensationResponse?
    
    var cancellationToken: AnyCancellable?
    
    func getCEOData(from symbol: String) {
        print("symbol: \(symbol)")
        cancellationToken = IEXMachine.requestCEOInfo(from: symbol)
        .mapError({ (error) -> Error in
            print(error)
            return error
        })
        .sink(receiveCompletion: { _ in },
              receiveValue: {
                self.ceoData = $0
                print(self.ceoData)
        })
    }
}
