import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serializationError
}

class NetworkService {
    static let shared = NetworkService()
    private let cache = CacheManager.shared
    
    private init() {}

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        // 1. Construir a URL
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
      
      // 2. Tentar carregar do cache para requisições GET
      if endpoint.method == .get, let cachedData = cache.data(forKey: url.absoluteString) {
        do {
          let decodedObject = try JSONDecoder().decode(T.self, from: cachedData)
          // LOG DE DIAGNÓSTICO
          print("✅ [Cache HIT] Dados para a URL: \(url.absoluteString)")
          return decodedObject
        } catch {
        }
      }
      // 3. Construir a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue // Usar o rawValue do enum
        
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.serializationError
            }
        }
        
        endpoint.headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // 4. Executar a requisição
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
      // 5. Decodificar e colocar no cache (se for GET)
      do {
        let decodedObject = try JSONDecoder().decode(T.self, from: data)
        if endpoint.method == .get {
          cache.setData(data, forKey: url.absoluteString)
          // LOG DE DIAGNóstico
          print("📦 [Cache SET] Dados para a URL: \(url.absoluteString) salvos no cache.")
        }
        return decodedObject
      } catch {
        throw NetworkError.decodingError(error)
      }
    }
}
