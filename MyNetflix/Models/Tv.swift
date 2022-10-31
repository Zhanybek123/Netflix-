//
//  Tv.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/31/22.
//

import Foundation

struct TrendingTvResponse: Codable {
    let results: [Tv]
}

struct Tv: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let release_date : String?
    let vote_average: Double?
    let vote_count: Int?
}
