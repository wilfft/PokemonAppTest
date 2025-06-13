//
//  AsyncImageView.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//


import SwiftUI

struct AsyncImageView: View {
  @StateObject private var loader: ImageLoader
  
  private let cache = CacheManager.shared
  init(url: URL?) {
    _loader = StateObject(wrappedValue: ImageLoader(url: url ?? URL(string: "invalid")!))
  }
  
  var body: some View {
    Group {
      if let image = loader.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else {
        ProgressView()
      }
    }
    .onAppear(perform: loader.load)
  }
}
