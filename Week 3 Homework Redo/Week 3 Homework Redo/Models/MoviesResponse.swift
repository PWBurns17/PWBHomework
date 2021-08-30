//
//  MoviesResponse.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie] //Array<Movie>
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}
