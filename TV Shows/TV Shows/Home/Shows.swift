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
    let averageRating: Double?
    let description: String?
    let imageUrl: String
    let noOfReviews: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case averageRating = "average_rating"
        case imageUrl = "image_url"
        case noOfReviews = "no_of_reviews"
    }
}

struct ShowsResponse: Decodable {
    let shows: [Show]
}

