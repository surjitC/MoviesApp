//
//  ViewController.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import UIKit

class ViewController: UIViewController {

    enum HomePage {
        case Searching
        case DefaultIndex
    }
    
    @IBOutlet var categoryTableView: UITableView!
    
    let movieCategoryViewModel = MovieCategoryViewModel()
    var homepage: HomePage = .DefaultIndex
    
    var imageDownloader = ImageDownloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.categoryTableView.tableFooterView = UIView()
        self.categoryTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.movieCategoryViewModel.resetData()
        self.movieCategoryViewModel.delegate = self
        self.movieCategoryViewModel.getAllMovies()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homepage == .DefaultIndex ? self.movieCategoryViewModel.getCategoryCount() : self.movieCategoryViewModel.filteredMovies.isEmpty ? 1 : self.movieCategoryViewModel.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch homepage {
        case .DefaultIndex:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = self.movieCategoryViewModel.getCategoryName(from: indexPath.row)
            return cell
        case .Searching:
            if self.movieCategoryViewModel.filteredMovies.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellId, for: indexPath) as? MovieTableViewCell else {
                preconditionFailure("Failed to load movie cell")
            }
            
            let movie = self.movieCategoryViewModel.getFilteredMovies(from: indexPath.row)
            cell.configureCell(for: movie)
            self.imageDownloader.loadImage(from: movie.poster, completionHandler: { (image) in
                    if let updateCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                        updateCell.posterImageView.contentMode = image == #imageLiteral(resourceName: "imagePlaceholder") ? .scaleAspectFit : .scaleAspectFill
                        updateCell.posterImageView.image = image
                    }
                })
            return cell
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.homepage {
        case .DefaultIndex:
            self.movieCategoryViewModel.setSelectedCategory(from: indexPath.row)
            let vc = CategoryViewController.initializeVC()
            vc.movieCategoryViewModel = self.movieCategoryViewModel
            self.navigationController?.pushViewController(vc, animated: true)
        case .Searching:
            if !self.movieCategoryViewModel.filteredMovies.isEmpty {
                let vc = MovieDetailsViewController.initializeVC()
                let movie = self.movieCategoryViewModel.getFilteredMovies(from: indexPath.row)
                vc.movie = movie
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}

extension ViewController: MovieCategoryViewModelDelegate {
    func didFinishDownloadingData(success: Bool) {
        DispatchQueue.main.async {
            self.categoryTableView.reloadData()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.imageDownloader.urlResquest?.invalidateAndCancel()
        if searchText.isEmpty {
            self.homepage = .DefaultIndex
        } else {
            self.homepage = .Searching
            self.movieCategoryViewModel.filterMovies(by: searchText)
        }
        self.categoryTableView.reloadData()
    }
}
