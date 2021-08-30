//
//  MovieListViewController.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import UIKit
import Combine

class MovieListViewController: UIViewController {
    
    private var viewModel: MovieViewModelType = MovieViewModel()
    private var subscribers = Set<AnyCancellable>()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet private weak var movieListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func onEditButtonClick(_ sender: Any) {
        
        var vc = storyboard?.instantiateViewController(identifier: "InitialViewController") as! InitialViewController
//        if var parsed = nameLabel.text {
//            vc.nameTextField.text = parsed.replacingOccurrences(of: "Hello: ", with: "") ?? ""
//ß        }
        present(vc, animated: true)
    }
    
//    @IBAction func showDetailsButton(_ sender: Any) {
//
//        let vc = storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
//        //vc.titleLabel.text = nameTextField.text ?? ""
//        present(vc, animated: true)
//    }
//    func movieListTableView(_ movieListTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // The vc no longer stores an array of movies so I'm fetching them again to get the array
//        let movies: [Movie] =
//        let movie = movies[indexPath.row]
//        let detailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
//
//
//        detailView.myItem = item
//        self.navigationController?.pushViewController(detailView, animated: false)
//        //navigationController?.pushViewController(detailView, animated: false)
//    }
    
    var name: String = ""
    var searching = false
    //var movieList: [String]()
    //var searchedMovie: [String]()
    
    required init?(coder aDecoder: NSCoder) {
        self.name = ""
        super.init(coder: aDecoder)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        setUpBinding()
        nameLabel.text = "Hello: \(name)"
    }
    
    private func setUpBinding() {
        print("inMLVCSetupBinding")
        // create binding of movies
        viewModel
            .moviesBinding
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.movieListTableView.reloadData()
            }
            .store(in: &subscribers)
        
        // create binding for errors
        viewModel
            .errorBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] messageError in
                self?.displayErrorAlert(messageError)
            }
            .store(in: &subscribers)
        
        // binding to update row
        viewModel
            .updateRowBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] row in
                self?.movieListTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            }
            .store(in: &subscribers)
        
        viewModel.fetchMovies()
    }
    
    private func displayErrorAlert(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default)
        alert.addAction(acceptAction)
        present(alert, animated: true)
    }
    
}

extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ movieListTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("inMLVCNumberofRowsInSection")
//        if searching {
//            return searchedMovie.count
//        }
//        else{
            return viewModel.count
      //  }
    }
    
    func tableView(_ movieListTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("inMLVCCellForRowAr")
//        if searching {
//
//        }
//        else{
//            guard let cell = movieListTableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell
//            else { return UITableViewCell() }
//
//            let row = indexPath.row
//            let title = viewModel.getTitle(at: row)
//            let overview = viewModel.getOverview(at: row)
//            let data = viewModel.getImage(at: row)
//            cell.configureCell(title: title, overview: overview, imageData: data)
//        }
        guard let cell = movieListTableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell
        else { return UITableViewCell() }
        
        let row = indexPath.row
        let title = viewModel.getTitle(at: row)
        let overview = viewModel.getOverview(at: row)
        let data = viewModel.getImage(at: row)
        cell.configureCell(title: title, overview: overview, imageData: data)
        
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ movieListTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let movieCell = MovieCell()
        
        return movieCell.getHeight(text: viewModel.getOverview(at: indexPath.row), font: UIFont.systemFont(ofSize: 17) , width: 281.5) + 80
    }
}
