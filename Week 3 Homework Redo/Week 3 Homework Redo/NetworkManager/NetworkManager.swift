//
//  NetworkManager.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import Foundation
import Combine

class NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func getMovies(from urlS: String) -> AnyPublisher<[Movie], NetworkError> {
        print("inNMgetMovies")
        guard let url = URL(string: urlS) else {
            return Fail(error: .url).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: url)
            .map { $0.0 }
            .decode(type: MoviesResponse.self, decoder: decoder)
            .map { $0.results }
            .mapError({ _ in
                return NetworkError.serverError
            })
            .eraseToAnyPublisher()
        
    }
    
    func getImageData(from urlS: String) -> AnyPublisher<Data, NetworkError> {
        print("inNMgetImageData")
        guard let url = URL(string: urlS) else {
            return Fail(error: .url).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError({ _ in
                return NetworkError.serverError
            })
            .eraseToAnyPublisher()
    }
    
//    func getMovies(from urlS: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
//
//        guard let url = URL(string: urlS) else {
//            completion(Result.failure(NetworkError.url))
//            return
//        }
//
//        session.dataTask(with: url) { [weak self] (data, response, error) in
//
//            if let error = error {
//                completion(.failure(.other(error)))
//                return
//            }
//
//            if let data = data {
//                do {
//                    let response = try self?.decoder.decode(MoviesResponse.self, from: data)
//                    let movies = response?.results ?? []
//                    completion(.success(movies))
//                    return
//                } catch (let error) {
//                    completion(.failure(.other(error)))
//                }
//            }
//        }.resume()
//
//    }
    
}
