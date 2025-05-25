import Foundation

public protocol RemoteAPI: APIErrorHandler {
    static func request<T: Codable>(_ service: RemoteService) async throws -> Response<T>
}

public struct NetworkApi: RemoteAPI {    
    public static func request<T: Decodable>(_ service: RemoteService) async throws -> Response<T> {
        do {
            let urlRequest = try service.asURLRequest()
            debugPrint(urlRequest)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    debugPrint(httpResponse.statusCode)
                    throw handleNetworkResponse(data: data, response: response)
                }
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(Response<T>.self, from: data)
            return decodedData
        } catch let decodingError as DecodingError {
            throw APIError.jsonParsingFailed(error: decodingError)
        } catch {
            debugPrint(error)
            throw APIError.unknown(error)
        }
    }
}
