//
//  Defaults.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 2/11/22.
//

class Defaults {
    class URL {
        static let host = "https://exhentai.org/"
        static let cookiesVerify = "https://e-hentai.org/"
        static let login = "https://forums.e-hentai.org/index.php?act=Login"
        
        static let favorites = "favorites.php"
        static let search = "?f_search="
        static let detailLarge = "?inline_set=ts_l"
        
        static func addFavorite(id: String, token: String) -> String {
            "gallerypopups.php?gid=\(id)&t=\(token)&act=addfav"
        }
    }
}
