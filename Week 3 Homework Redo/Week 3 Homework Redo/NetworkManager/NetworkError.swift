//
//  NetworkError.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import Foundation

enum NetworkError: Error {
    case url
    case other(Error)
    case serverError
}
