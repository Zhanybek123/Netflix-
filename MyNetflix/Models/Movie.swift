//
//  Movie.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/24/22.
//

import Foundation

struct TrendingMoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int?
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let release_date : String?
    let vote_average: Double?
    let vote_count: Int?
}
