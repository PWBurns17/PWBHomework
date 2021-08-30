//
//  MovieViewModel.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import Foundation
import Combine
import CoreData

protocol MovieViewModelType {
    var count: Int { get }
    var moviesBinding: PassthroughSubject<Void, Never> { get }
    var errorBinding: Published<String>.Publisher { get }
    var updateRowBinding: Published<Int>.Publisher { get }
    func fetchMovies()
    func getTitle(at row: Int) -> String
    func getOverview(at row: Int) -> String
    func getImage(at row: Int) -> Data?
}

class MovieViewModel: MovieViewModelType {
    // communication = closure, delegate/protocol, observer
    
    // MARK:- internal properties
    let moviesBinding = PassthroughSubject<Void, Never>()
    var errorBinding: Published<String>.Publisher { $messageError }
    var updateRowBinding: Published<Int>.Publisher { $updateRow }
    
    @Published private var updateRow = 0
    @Published private var messageError = ""
    @Published private var movies = [Movie]()
    
    var count: Int { movies.count }
    func getTitle(at row: Int) -> String { movies[row].originalTitle }
    func getOverview(at row: Int) -> String { movies[row].overview }
    
    // MARK:- private properties
    private let networkManager = NetworkManager()
    private var subscribers = Set<AnyCancellable>()
    private var imagesCache = [String: Data]()
    
    // MARK:- internal properties
    func fetchMovies() {
        print("func fetchMovies")
        // See if I have data in CoreData
        let moviesStored = fetchAllMovies()
        if !moviesStored.isEmpty {
            print("func fetchMovies moviesStored not empty")
            let temp = moviesStored.map { CDMovie in
                return Movie(CDMovie)
            }
            movies = temp
            return
        }
        
        // create the url
        print("inMVMfetchMovies")
        let urlS = "https://api.themoviedb.org/3/movie/popular?api_key=6622998c4ceac172a976a1136b204df4&language=en-US"
        
        networkManager
            .getMovies(from: urlS)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.messageError = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.saveMovies(movies)
                self?.movies = movies
                self?.moviesBinding.send()
            }
            .store(in: &subscribers)
    }
    
    func getImage(at row: Int) -> Data? {
        print("inMVMgetImage")
        let movie = movies[row]
        let posterPath = movie.posterPath
        
        if let data = imagesCache[posterPath] {
            return data
        }
        
        let urlS = "https://image.tmdb.org/t/p/w500\(posterPath)"
        networkManager
            .getImageData(from: urlS)
            .sink { _ in }
                receiveValue: { [weak self] data in
                    self?.imagesCache[posterPath] = data
                    self?.updateRow = row
            }
            .store(in: &subscribers)

        return nil
    }
    
    // MARK: - private funcs
    private func fetchAllMovies() -> [CDMovie]{
        print("func fetchAllMovies")
        let fetch: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        let fetch2 = NSFetchRequest<CDMovie>(entityName: "CDMovie")
        let context = CoreDataManager.shared.mainContext
        
        var movies = [CDMovie]()
        do {
            try movies = context.fetch(fetch)
        } catch { return movies }
        return movies
    }
    
    private func saveMovies(_ movies: [Movie]){
        print("func saveMovies")
        for movie in movies {
            let context = CoreDataManager.shared.mainContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: "CDMovie", in: context)
            else { continue }
            
            let cdMovie = CDMovie(entity: entity, insertInto: context)
            cdMovie.identifier = Int64(movie.identifier)
            cdMovie.originalTitle = movie.originalTitle
            cdMovie.overview = movie.overview
            cdMovie.posterPath = movie.posterPath
            
            CoreDataManager.shared.saveContext(context)
        }
    }
}
