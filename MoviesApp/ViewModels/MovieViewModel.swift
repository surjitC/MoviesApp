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
}
