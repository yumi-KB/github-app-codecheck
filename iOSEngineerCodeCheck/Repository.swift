import Foundation

struct Owner: Codable {
    let avatarUrl: String?
    //let htmlUrl: String?
}

struct Repository: Codable {
    let fullName: String?
    let owner: Owner?
    //let htmlUrl: String?
    let description: String?
    
    let stargazersCount: Int?
    let language: String?
    let watchersCount: Int?
    let forksCount: Int?
    let openIssuesCount: Int?
}

struct Result: Codable {
    //let total_count: Int?
    let items: [Repository]?
}
