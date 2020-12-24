//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchController: UISearchController!
    
    let url = "https://api.github.com/search/repositories"
    var queryItems: [URLQueryItem] = []
    var pageCount = 2
    
    var repositories: [Repository] = []
    
    var task: URLSessionTask?
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    // MARK: Methods
    func setTableData(json: Result) {
        if let items = json.items {
            self.repositories.append(contentsOf: items)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func apiRequest(url: String, query queryItems: [URLQueryItem]? = nil, completion: @escaping() -> Void) {
        guard var components = URLComponents(string: url) else { return }
        components.queryItems = queryItems
        guard let requestURL = components.url else { return }
        
        task = URLSession.shared.dataTask(with: requestURL) { (data, res, err) in
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
                
                self.setTableData(json: object)
                completion()
                
            } catch {
                print("parse error")
            }
        }
        // URLSession開始
        task?.resume()
    }
    
    // MARK: Private Methods
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "リポジトリ名を入力"
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.title = "GitHub リポジトリ検索"
        if #available(iOS 11.0, *) {
            // UISearchControllerをUINavigationItemのsearchControllerプロパティにセットする。
            navigationItem.searchController = searchController
            
            // trueだとスクロールした時にSearchBarを隠す（デフォルトはtrue）
            // falseだとスクロール位置に関係なく常にSearchBarが表示される
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchController.searchBar.delegate = self
    }
    
    private func setRepositoryCell(cell repositoryCell: UITableViewCell, repository: Repository, tag: Int) {
        repositoryCell.textLabel?.text = repository.fullName
        repositoryCell.detailTextLabel?.text = repository.language
        repositoryCell.tag = tag
    }
}

// MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // URLSessionキャンセル
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchWord = searchBar.text {
            // 初期化
            pageCount = 2
            repositories = []
            queryItems = [URLQueryItem(name: "q", value: "\(searchWord)")]
            // APIリクエスト
            apiRequest(url: url, query: queryItems, completion: {})
        }
    }
}

// MARK: - TableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repositoryCell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        
        let repository = repositories[indexPath.row]
        setRepositoryCell(cell: repositoryCell, repository: repository, tag: indexPath.row)
        return repositoryCell
    }
}

// MARK: - TableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == repositories.count {
            // クエリの追加
            var queryItemsAddPage = queryItems
            queryItemsAddPage.append(URLQueryItem(name: "page", value: "\(pageCount)"))
            // APIリクエスト
            apiRequest(url: url, query: queryItemsAddPage, completion: {
                self.pageCount += 1
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        index = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detailViewController = segue.destination as? DetailViewController else { return }
            detailViewController.searchViewController = self
        }
    }
}
