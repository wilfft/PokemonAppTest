//
//  CacheManager.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation
import UIKit

// MARK: TODO- implement cache limit, count and size

class CacheManager {
    static let shared = CacheManager()
    private init() {}

    private let dataCache = NSCache<NSString, NSData>()
    private let imageCache = NSCache<NSString, UIImage>()

    func setData(_ data: Data, forKey key: String) {
        dataCache.setObject(data as NSData, forKey: key as NSString)
    }

    func data(forKey key: String) -> Data? {
        return dataCache.object(forKey: key as NSString) as Data?
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }

    func image(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
