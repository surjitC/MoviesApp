//
//  MovieViewModel.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import Foundation

class MovieViewModel {
    
    private var movies: Movies = []
    
    init(movies: Movies) {
        self.movies = movies
    }
    
    func getMoviesCount() -> Int {
        self.movies.count
    }
    
    func getMovie(from row: Int) -> MovieModel {
        return self.movies[row]
    }
    
    func sortMovies(value: Int)  {
        switch value {
        case 0:
            self.movies.sort { (a, b) -> Bool in
                let aBox = a.boxOffice?.components(separatedBy: "$").last
                let bBox = a.boxOffice?.components(separatedBy: "$").last
                
                if let aVal = Double(aBox ?? "0"), let bVal = Double(bBox ?? "0") {
                    return aVal < bVal
                }
                return a.boxOffice ?? "" < b.boxOffice ?? ""
            }
        case 1:
            self.movies.sort { (a, b) -> Bool in
                a.year ?? "" < b.year ?? ""
            }
        case 2:
            self.movies.sort { (a, b) -> Bool in
                if let aVal = Double(a.imdbRating ?? "0"), let bVal = Double(b.imdbRating ?? "0") {
                    return aVal < bVal
                }
                return a.imdbRating ?? "" > b.imdbRating ?? ""
            }
        default:
            break
        }
    }
}
