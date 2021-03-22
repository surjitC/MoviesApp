//
//  CategoryViewController.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    class func initializeVC() -> CategoryViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryViewController") as?  CategoryViewController else {
            return CategoryViewController()
        }
        return vc
    }
    
    var movieCategoryViewModel: MovieCategoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let selectedCategoryInt = self.movieCategoryViewModel?.selectedCategory?.rawValue ?? 0
        self.title = self.movieCategoryViewModel?.getCategoryName(from: selectedCategoryInt)
        self.movieCategoryViewModel?.createCategories()
    }

}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieCategoryViewModel?.catageries.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.textLabel?.text = self.movieCategoryViewModel?.catageries[indexPath.row]
        return cell
    }
    
    
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieViewController.initializeVC()
        if let cat = self.movieCategoryViewModel?.catageries[indexPath.row] {
            let movies = self.movieCategoryViewModel?.fetchMovies(with: cat) ?? []
            let movieViewModel = MovieViewModel(movies: movies)
            vc.movieViewModel = movieViewModel
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
