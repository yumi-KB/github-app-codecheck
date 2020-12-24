//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var searchViewController: SearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repository = searchViewController.repositories[searchViewController.index]
        
        languageLabel.text = "Written in \(repository.language ?? "")"
        starsLabel.text = "\(repository.stargazersCount ?? 0) stars"
        watchersLabel.text = "\(repository.watchersCount ?? 0) watchers"
        forksLabel.text = "\(repository.forksCount ?? 0) forks"
        issuesLabel.text = "\(repository.openIssuesCount ?? 0) open issues"
        setImage(repository: repository)
    }
    
    func setImage(repository: Repository) {
        tableLabel.text = repository.fullName
        
        guard let owner = repository.owner else { return }
        guard let imageURL = URL(string: owner.avatarUrl ?? "") else { return }
        URLSession.shared.dataTask(with: imageURL) { (data, res, err) in
            guard let data = data, let res = res as? HTTPURLResponse else {
                print("response error")
                return
            }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}
