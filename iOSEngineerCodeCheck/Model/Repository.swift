import Foundation

struct Owner: Codable {
    let avatarUrl: String?
}

struct Repository: Codable {
    let fullName: String?
    let owner: Owner?
    let description: String?
    
    let stargazersCount: Int?
    let language: String?
    let watchersCount: Int?
    let forksCount: Int?
    let openIssuesCount: Int?
}

struct Result: Codable {
    let totalCount: Int?
    let items: [Repository]?
}
