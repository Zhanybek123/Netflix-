//
//  YoutubeSeachResponse.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 4/12/23.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementId
}

struct VideoElementId: Codable {
    let kind: String
    let videoId: String
}



