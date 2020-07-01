//
//  ButtonStyles.swift
//  stocks
//
//  Created by Alexander Rohrig on 6/30/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI

struct FilledBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .padding()
            .background(Color(UIColor.systemBlue))
            .cornerRadius(8)
    }
}

struct FilledOrangeButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .padding()
            .background(Color(UIColor.systemOrange))
            .cornerRadius(8)
    }
}
