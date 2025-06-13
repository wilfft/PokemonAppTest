//
//  Untitled.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//


import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    @State private var image: UIImage? = nil
    private let cache = CacheManager.shared

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        guard let url = url else { return }
        
        // Check cache
        if let cachedImage = cache.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }
        
        // Fetch image
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    // Cache and set image
                    cache.setImage(uiImage, forKey: url.absoluteString)
                    self.image = uiImage
                }
            } catch {
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}
