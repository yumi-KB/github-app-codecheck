import UIKit

class APIClient {
    
    let url = "https://api.github.com/search/repositories"
    let queryItems: [URLQueryItem]
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    weak var searchViewController: SearchViewController?
    
    // MARK: Initialization
    init(queryItems: [URLQueryItem]) {
        self.queryItems = queryItems
        
        searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
    }
    
    // MARK: Methods
    func getRequestURL() -> URL? {
        guard var components = URLComponents(string: url) else { return nil }
        components.queryItems = self.queryItems
        guard let requestURL = components.url else { return nil }
        return requestURL
    }
    
    func request(url: URL, completion: @escaping(Result) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let err = err {
                print("error: \(err.localizedDescription)\n")
                return
            }
            guard let data = data, let _ = res as? HTTPURLResponse else {
                print("response error")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let object = try decoder.decode(Result.self, from: data)
                completion(object)
                
            } catch {
                print("parse error")
                return
            }
        }
        // URLSession開始
        task.resume()
    }
}
