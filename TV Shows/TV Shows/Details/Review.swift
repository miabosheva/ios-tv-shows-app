//
//  Review.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 28.7.23.
//

import Foundation

struct ReviewResponse : Decodable {
    var reviews: [Review]
}

struct Review : Decodable {
    var id: String
    var comment: String
    var rating: Int
    var show_id: Int
    var user: User
}

struct ReviewSubmitResponse : Decodable {
    var review: Review
}
