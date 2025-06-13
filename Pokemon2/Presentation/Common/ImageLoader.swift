//
//  ImageLoader.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class ImageLoader: ObservableObject {
  @Published var image: UIImage?
  
  private static let cache = CacheManager.shared
  private static var runningTasks: [URL: Task<UIImage, Error>] = [:]
  
  private let url: URL
  
  init(url: URL) {
    self.url = url
  }
  
  func load() {
    // cache first approach
    if let cachedImage = Self.cache.image(forKey: url.absoluteString) {
      print("🖼️ [Cache HIT] Imagem carregada do cache: \(url.lastPathComponent)")
      self.image = cachedImage
      return
    }
    
    // Check if there is already a task is progress for this url
    if let runningTask = Self.runningTasks[url] {
      print("⏳ [Task JOIN] Aguardando tarefa existente para: \(url.lastPathComponent)")
      // if yes, merge it to the existing task to obtain the result
      Task {
        self.image = try? await runningTask.value
      }
      return
    }
    
    // If there is no cache or task in progress, create a new task
    print("🌐 [Network] Iniciando nova tarefa de download para: \(url.lastPathComponent)")
    let task = Task<UIImage, Error> {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let downloadedImage = UIImage(data: data) else {
        throw URLError(.cannotDecodeContentData)
      }
      
      // save in cache before returning
      
      Self.cache.setImage(downloadedImage, forKey: url.absoluteString)
      print("💾 [Cache SET] Imagem salva no cache: \(url.lastPathComponent)")
      return downloadedImage
    }
    
    Self.runningTasks[url] = task
    
    // wait for the result and update the image
    Task {
      do {
        self.image = try await task.value
      } catch {
        print("❌ Falha ao carregar imagem: \(error.localizedDescription)")
      }
      // Remove the task from the dict when it is concluded
      // Remove a tarefa do dicionário quando ela for concluída (com sucesso ou erro)
      Self.runningTasks[url] = nil
    }
  }
}
