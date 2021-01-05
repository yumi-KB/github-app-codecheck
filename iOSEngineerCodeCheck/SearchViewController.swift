import UIKit
import MBProgressHUD

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchController: UISearchController!
    
    // MARK: Properties
    
    /// API通信に関するプロパティ
    let url = "https://api.github.com/search/repositories"
    var queryItems: [URLQueryItem] = []
    var pageCount = 2
    var totalCount = 0
    
    /// 取得したリポジトリ一覧を格納
    var repositories: [Repository] = []
    
    var task: URLSessionTask?
    var index: Int = 0
    
    /// 検索用のIndicator
    var hud = MBProgressHUD()
    /// テーブル最下部読み込み時の Indicator
    var indicator: UIActivityIndicatorView! = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    
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
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = true

        
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
        /// URLSessionをキャンセル
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchWord = searchBar.text {
            /// クエリとデータを格納する配列の初期化
            repositories = []
            pageCount = 2
            queryItems = [URLQueryItem(name: "q", value: "\(searchWord)")]
            
            /// Indicator 表示開始
            hud = MBProgressHUD.showAdded( to: self.view, animated: true)
            hud.label.text = "Searching..."
            
            /// APIリクエスト
            let api = APIClient(queryItems: queryItems)
            guard let requestUrl = api.getRequestURL() else { return }
            
            api.request(url: requestUrl, completion: { object in
                /// Indicator 表示終了
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                if let object = object {
                    self.totalCount = object.totalCount ?? 0
                    self.setTableData(object)
                } else {
                    print("error")
                }
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
        /// テーブル最下部を読み込むと次のAPIリクエストを取得する
        if indexPath.row + 1 == repositories.count {
            if repositories.count == totalCount {
                return
            }
            /// Indicator 表示開始
            indicator.startAnimating()
            indicator.center = self.view.center
            self.view.addSubview(indicator)
            
            /// クエリの追加
            var queryItemsAddPage = queryItems
            queryItemsAddPage.append(URLQueryItem(name: "page", value: "\(pageCount)"))
            
            /// API リクエスト
            let api = APIClient(queryItems: queryItemsAddPage)
            guard let requestUrl = api.getRequestURL() else { return }
            
            api.request(url: requestUrl, completion: { object in
                /// Indicator 表示終了
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
                
                if let object = object {
                    self.setTableData(object)
                    self.pageCount += 1
                } else {
                    print("error")
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        /// 画面遷移時に使用するプロパティ
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
