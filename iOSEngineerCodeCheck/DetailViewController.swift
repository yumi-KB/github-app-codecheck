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
        
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["watchers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
        
    }
    
    func getImage(){
        
        let repository = searchViewController.repositories[searchViewController.index]
        
        tableLabel.text = repository["full_name"] as? String
        
        if let owner = repository["owner"] as? [String: Any] {
            if let imageURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, res, err) in
                    let image = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }.resume()
            }
        }
        
    }
    
}
