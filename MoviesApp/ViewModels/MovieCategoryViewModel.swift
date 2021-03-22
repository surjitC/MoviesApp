//
//  MovieCategoryViewModel.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import Foundation

typealias Movies = [MovieModel]

protocol MovieCategoryViewModelDelegate: AnyObject {
    func didFinishDownloadingData(success: Bool) -> Void
}
class MovieCategoryViewModel {

    enum Category: Int, CaseIterable {
        case Year
        case Genre
        case Director
        case Actor
        case AllMovies
    }
    
    weak var delegate: MovieCategoryViewModelDelegate?

    var movies: Movies = []
    var filteredMovies: Movies = []
    var categoryDict: [String: Movies] = [:]
    var selectedCategory: Category?
    
    var catageries: [String] = []
    
    func getAllMovies() {
        let jsonParserUtility = JsonParserUtility()
        
        jsonParserUtility.parseJson(fileName: .Movie, resultType: Movies.self) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies
                debugPrint(self.movies.count)
                self.delegate?.didFinishDownloadingData(success: true)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.delegate?.didFinishDownloadingData(success: true)
            }
        }
    }
    
    func resetData() {
        self.catageries = []
        self.categoryDict = [:]
        self.selectedCategory = .none
        self.delegate = .none
    }
}

extension MovieCategoryViewModel {
    func getCategoryCount() -> Int {
        return Category.allCases.count
    }
    
    func getCategoryName(from row: Int) -> String {
        let category = Category(rawValue: row)
        switch category {
        case .Year:
            return "Year"
        case .Genre:
            return "Genre"
        case .Director:
            return "Directors"
        case .Actor:
            return "Actors"
        default:
            return "All Movies"
        }
    }
    
    func setSelectedCategory(from row: Int) {
        self.selectedCategory = Category(rawValue: row)
    }
}
extension MovieCategoryViewModel {
    func addCategoryString(_ value: String) {
        if self.categoryDict[value] == nil {
            self.catageries.append(value)
            self.categoryDict[value] = Movies()
        }
    }
    
    func createCategories() {
        self.movies.forEach { movie in
            switch selectedCategory {
            case .Year:
                if let year = movie.year {
                    self.addCategoryString(year)
                }
            case .Genre:
                if let genre = movie.genre {
                    self.covertToSingleCategory(from: genre, movie)
                }
            case .Director:
                if let director = movie.director {
                    self.covertToSingleCategory(from: director, movie)
                }
            case .Actor:
                if let actors = movie.actors {
                    self.covertToSingleCategory(from: actors, movie)
                }
            default:
                break
            }
            
        }
    }
    
    private func covertToSingleCategory(from line: String, _ movie: MovieModel) {
        let keys = line.components(separatedBy: ",")
        keys.forEach { key in
            self.addCategoryString(key.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    private func addToCategory(with key: String, _ movie: MovieModel) {
        if self.categoryDict[key] == nil {
            self.categoryDict[key] = Movies()
        }
        self.categoryDict[key]?.append(movie)
    }
    
    func fetchMovies(with category: String) -> Movies {
        let newMovies = self.movies.filter { movie -> Bool in
            switch selectedCategory {
            case .Year:
                return (movie.year?.lowercased().contains(category.lowercased()) ?? false)
            case .Genre:
                return (movie.genre?.lowercased().contains(category.lowercased()) ?? false)
            case .Director:
                return (movie.director?.lowercased().contains(category.lowercased()) ?? false)
            case .Actor:
                return (movie.actors?.lowercased().contains(category.lowercased()) ?? false)
            default:
                return false
            }
        }
        return newMovies
    }
    
    func filterMovies(by searchString: String) {
        self.filteredMovies = movies.filter { movie -> Bool in
            movie.title?.lowercased().contains(searchString.lowercased()) ?? false  ||
                movie.actors?.lowercased().contains(searchString.lowercased()) ?? false  ||
                movie.director?.lowercased().contains(searchString.lowercased()) ?? false  ||
                movie.genre?.lowercased().contains(searchString.lowercased()) ?? false
        }
    }
    
    func getFilteredMovies(from row: Int) -> MovieModel {
        return filteredMovies[row]
    }
}
