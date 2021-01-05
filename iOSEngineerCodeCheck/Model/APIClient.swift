import UIKit

class APIClient {
    
    let url = "https://api.github.com/search/repositories"
    let queryItems: [URLQueryItem]
    
    
    // MARK: Initialization
    
    init(queryItems: [URLQueryItem]) {
        self.queryItems = queryItems
    }
    
    // MARK: Methods
    
    func getRequestURL() -> URL? {
        
        guard var components = URLComponents(string: url) else { return nil }
        components.queryItems = self.queryItems
        guard let requestURL = components.url else { return nil }
        return requestURL
    }
    
    func request(url: URL, completion: @escaping(Result?) -> Void) {
        
        var requestUrl = URLRequest(url: url)
        requestUrl.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, res, err) in 
            if let err = err {
                print("error: \(err.localizedDescription)\n")
                completion(nil)
            }
            guard let data = data, let _ = res as? HTTPURLResponse else {
                print("response error")
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let object = try decoder.decode(Result.self, from: data)
                completion(object)
                
            } catch {
                print("parse error")
                completion(nil)
            }
        }
        /// URLSession開始
        task.resume()
    }
}
