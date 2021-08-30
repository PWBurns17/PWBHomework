//
//  Movie.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import Foundation

struct Movie: Decodable {
    let identifier: Int
    let overview: String
    let originalTitle: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case overview
        case originalTitle = "original_title"
        case posterPath = "poster_path"
    }
    
    init (_ movie: CDMovie){
        identifier = Int(movie.identifier)
        overview = movie.overview ?? ""
        originalTitle = movie.originalTitle ?? ""
        posterPath = movie.posterPath ?? ""
    }
    
//    init (){
//        identifier = 0
//        overview = ""
//        originalTitle = ""
//        posterPath = ""
//    }
}
