//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchController: UISearchController!
    
    var repositories: [[String: Any]] = []
    
    var task: URLSessionTask?
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
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
    
}

// MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchBar.textが編集され検索ボタンが押された時、URLSessionが行われていればキャンセルする
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchWord = searchBar.text {
            
            let url = "https://api.github.com/search/repositories"
            let queryItems = [URLQueryItem(name: "q", value: "\(searchWord)")]
            
            guard var components = URLComponents(string: url) else { return }
            components.queryItems = queryItems
            guard let requestURL = components.url else { return }
            
            task = URLSession.shared.dataTask(with: requestURL) { (data, res, err) in
                guard let data = data else {
                    print("error")
                    return
                }
                do {
                    let object = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    
                    if let items = object?["items"] as? [[String: Any]] {
                        self.repositories = items
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("error")
                }
            }
            // リストの更新
            task?.resume()
        }
    }
    
}

// MARK: - TableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
}

// MARK: - TableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        index = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.searchViewController = self
        }
    }
}
