import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serializationError
}

final class NetworkService {
    static let shared = NetworkService()
    private let cache = CacheManager.shared
    
    private init() {}

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
      
      // Loading from Cache when its was a Get Request
      if endpoint.method == .get, let cachedData = cache.data(forKey: url.absoluteString) {
        do {
          let decodedObject = try JSONDecoder().decode(T.self, from: cachedData)
          print("✅ [Cache HIT] Dados para a URL: \(url.absoluteString)")
          return decodedObject
        } catch { // ignore and continue to downloading
        }
      }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
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

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
      // Store in the cache
      do {
        let decodedObject = try JSONDecoder().decode(T.self, from: data)
        if endpoint.method == .get {
          cache.setData(data, forKey: url.absoluteString)
          print("📦 [Cache SET] Dados para a URL: \(url.absoluteString) salvos no cache.")
        }
        return decodedObject
      } catch {
        throw NetworkError.decodingError(error)
      }
    }
}
