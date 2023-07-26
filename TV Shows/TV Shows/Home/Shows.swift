//
//  Shows.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 26.7.23.
//

import Foundation

struct Show: Decodable {
    let id: String
    let title: String
}

struct ShowsResponse: Decodable {
    let shows: [Show]
    // for extra (Pagination data)
}
