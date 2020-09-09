//
//  ImageService.swift
//  stocks
//
//  Created by Alexander Rohrig on 7/1/20.
//  Copyright © 2020 Alexander Rohrig. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class ImageService: ObservableObject {
    @Published var image: Data?
    private let url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        print("loading logo")
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }
}

//struct AsyncImage<Placeholder: View>: View {
//    @ObservedObject private var loader: ImageService
//    private let placeholder: Placeholder?
//
//    init(url: URL, placeholder: Placeholder? = nil) {
//        loader = ImageService(url: url)
//        self.placeholder = placeholder
//    }
//
//    var body: some View {
//        image
//            .onAppear(perform: loader.load)
//            .onDisappear(perform: loader.cancel)
//    }
//
//    private var image: some View {
//        placeholder
//    }
//}
