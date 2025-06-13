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
    
    // Dicionário para rastrear tarefas de download em andamento.
    // A chave é a URL da imagem. O valor é a tarefa.
    private static var runningTasks: [URL: Task<UIImage, Error>] = [:]

    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() {
        // 1. Tenta carregar do cache primeiro
        if let cachedImage = Self.cache.image(forKey: url.absoluteString) {
            print("🖼️ [Cache HIT] Imagem carregada do cache: \(url.lastPathComponent)")
            self.image = cachedImage
            return
        }

        // 2. Verifica se já existe uma tarefa em andamento para esta URL
        if let runningTask = Self.runningTasks[url] {
            print("⏳ [Task JOIN] Aguardando tarefa existente para: \(url.lastPathComponent)")
            // Se sim, "junta-se" à tarefa existente para obter seu resultado
            Task {
                self.image = try? await runningTask.value
            }
            return
        }

        // 3. Se não houver cache nem tarefa em andamento, cria uma nova tarefa
        print("🌐 [Network] Iniciando nova tarefa de download para: \(url.lastPathComponent)")
        let task = Task<UIImage, Error> {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let downloadedImage = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            // Salva no cache antes de retornar
            Self.cache.setImage(downloadedImage, forKey: url.absoluteString)
            print("💾 [Cache SET] Imagem salva no cache: \(url.lastPathComponent)")
            return downloadedImage
        }

        Self.runningTasks[url] = task

        // 5. Aguarda o resultado da tarefa e atualiza a imagem
        Task {
            do {
                self.image = try await task.value
            } catch {
                print("❌ Falha ao carregar imagem: \(error.localizedDescription)")
            }
            // 6. Remove a tarefa do dicionário quando ela for concluída (com sucesso ou erro)
            Self.runningTasks[url] = nil
        }
    }
}
