//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchController: UISearchController!
    
    // MARK: Properties
    let url = "https://api.github.com/search/repositories"
    var queryItems: [URLQueryItem] = []
    var pageCount = 2
    
    var repositories: [Repository] = []
    
    var task: URLSessionTask?
    var index: Int = 0
    
    //var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    
    // MARK: Private Methods
    private func setTableData(_ json: Result) {
        if let items = json.items {
            repositories.append(contentsOf: items)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setRepositoryCell(cell repositoryCell: UITableViewCell, repository: Repository, tag: Int) {
        repositoryCell.textLabel?.text = repository.fullName
        repositoryCell.detailTextLabel?.text = repository.language
        repositoryCell.tag = tag
    }
    
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
            //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            let api = APIClient(queryItems: queryItems)
            guard let requestUrl = api.getRequestURL() else { return }
            api.request(url: requestUrl, completion: { object in
                self.setTableData(object)
            })
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
            //hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            let api = APIClient(queryItems: queryItemsAddPage)
            guard let requestUrl = api.getRequestURL() else { return }
            api.request(url: requestUrl, completion: { object in
                self.setTableData(object)
                self.pageCount += 1
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        searchController.searchBar.resignFirstResponder()
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
