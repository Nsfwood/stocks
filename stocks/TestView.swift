//
//  TestView.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/1/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct TestView: View {
    
    var testStock: Stock
    
    var body: some View {
        Text("Hello, \(testStock.name!)")
    }
}

//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView(create)
//    }
//}
