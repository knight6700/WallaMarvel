import Foundation

public protocol RemoteAPI: APIErrorHandler {
    static func request<T: Codable>(_ service: RemoteService) async throws -> Response<T>
}

public struct NetworkApi: RemoteAPI {    
    public static func request<T: Decodable>(_ service: RemoteService) async throws -> Response<T> {
        do {
            let urlRequest = try service.asURLRequest()
            let (data, response) = try await service.requestConfiguration.uRLSession.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw handleNetworkResponse(data: data, response: response)
                }
            }
            service.requestConfiguration.decoder.dateDecodingStrategy = .iso8601
            service.requestConfiguration.decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try service.requestConfiguration.decoder.decode(Response<T>.self, from: data)
            return decodedData
        } catch let decodingError as DecodingError {
            throw APIError.jsonParsingFailed(error: decodingError)
        } catch {
            throw APIError.unknown(error)
        }
    }
}
