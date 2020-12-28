//
//  PopularItemsRequest.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 2/12/26.
//

import Kanna
import Combine
import Foundation

struct SearchItemsRequest {
    let keyword: String
    let parser = Parser()
    
    var publisher: AnyPublisher<[Manga], AppError> {
        let word = keyword.replacingOccurrences(of: " ", with: "+")
        return URLSession.shared
            .dataTaskPublisher(
                for: URL(string: Defaults.URL.host
                            + Defaults.URL.search
                            + word)!
            )
            .tryMap { try Kanna.HTML(html: $0.data, encoding: .utf8) }
            .map { parser.parsePopularListItems($0) }
            .mapError { _ in .networkingFailed }
            .eraseToAnyPublisher()
    }
}

struct PopularItemsRequest {
    let parser = Parser()
    
    var publisher: AnyPublisher<[Manga], AppError> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: Defaults.URL.host)!)
            .tryMap { try Kanna.HTML(html: $0.data, encoding: .utf8) }
            .map { parser.parsePopularListItems($0) }
            .mapError { _ in .networkingFailed }
            .eraseToAnyPublisher()
    }
}

struct FavoritesItemsRequest {
    let parser = Parser()
    
    var publisher: AnyPublisher<[Manga], AppError> {
        URLSession.shared
            .dataTaskPublisher(
                for: URL(string: Defaults.URL.host
                            + Defaults.URL.favorites)!)
            .tryMap { try Kanna.HTML(html: $0.data, encoding: .utf8) }
            .map { parser.parsePopularListItems($0) }
            .mapError { _ in .networkingFailed }
            .eraseToAnyPublisher()
    }
}

struct MangaDetailRequest {
    let detailURL: String
    let parser = Parser()
    
    var publisher: AnyPublisher<MangaDetail?, AppError> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: detailURL)!)
            .tryMap { try Kanna.HTML(html: $0.data, encoding: .utf8) }
            .map { parser.parseMangaDetail($0) }
            .mapError { _ in .networkingFailed }
            .eraseToAnyPublisher()
    }
}

struct AddFavoriteRequest {
    let id: String
    let token: String
    
    var publisher: AnyPublisher<Any, AppError> {
        let url = Defaults.URL.host + Defaults.URL.addFavorite(id: id, token: token)
        let parameters: [String: String] = ["favcat": "0",
                                            "favnote": "",
                                            "apply": "Add to Favorites",
                                            "update": "1"]
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.httpBody = getStringFrom(dic: parameters).data(using: .utf8)
        
        return session.dataTaskPublisher(for: request)
            .map { $0 }
            .mapError { _ in .networkingFailed}
            .eraseToAnyPublisher()
    }
}

struct DeleteFavoriteRequest {
    let id: String
    
    var publisher: AnyPublisher<Any, AppError> {
        let url = Defaults.URL.host + Defaults.URL.favorites
        let parameters: [String: String] = ["ddact": "delete",
                                            "modifygids[]": id,
                                            "apply": "Apply"]
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.httpBody = getStringFrom(dic: parameters).data(using: .utf8)
        
        return session.dataTaskPublisher(for: request)
            .map { $0 }
            .mapError { _ in .networkingFailed}
            .eraseToAnyPublisher()
    }
}

