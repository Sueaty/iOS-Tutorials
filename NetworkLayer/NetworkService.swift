import Foundation

enum NetworkError: Error {
    case invalidURL
    case unsuccessfulResponse
    case APIInvalidResponse
    case unknownError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unsuccessfulResponse:
            return "Unsuccessful Response"
        case .APIInvalidResponse:
            return "API Invalid Response"
        case .unknownError(let message):
            return "Unkown error : \(message)"
        }
    }
}

enum RequestType: CustomStringConvertible {
    case get
    case post
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

typealias NetworkResult = ((Result<Data, NetworkError>) -> Void)

protocol NetworkServiceType {
    func request(request type: RequestType, url: String, body: Data?, completion: @escaping NetworkResult)
    // func downloadTaskRequest
}

final class NetworkService: NetworkServiceType {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session // custom session을 만들어 넣을 수도
    }
    
    func request(request type: RequestType = .get, url: String, body: Data?, completion: @escaping NetworkResult) {
        guard let url = URL(string: url) else {
            return completion(.failure(.invalidURL))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.description
        urlRequest.httpBody = body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError(message: error?.localizedDescription ?? "Unkown")))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.unsuccessfulResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.APIInvalidResponse))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    // func downloadTaskRequest(...)
}
