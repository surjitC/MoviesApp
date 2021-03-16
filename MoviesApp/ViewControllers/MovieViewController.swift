//
//  MovieViewController.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet var moviesTableView: UITableView!
    
    var movieViewModel: MovieViewModel?
    
    class func initializeVC() -> MovieViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieViewController") as?  MovieViewController else {
            return MovieViewController()
        }
        return vc
    }
    
    var imageDownloader = ImageDownloader()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Movies"
        self.moviesTableView.tableFooterView = UIView()
        self.moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imageDownloader.urlResquest?.invalidateAndCancel()
    }

}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieViewModel?.getMoviesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            preconditionFailure("Failed to load movie cell")
        }
        let movie = self.movieViewModel?.getMovie(from: indexPath.row)
        cell.configureCell(for: movie)
        
        self.imageDownloader.loadImage(from: movie?.poster, completionHandler: { (image) in
                if let updateCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                    updateCell.posterImageView.contentMode = image == #imageLiteral(resourceName: "imagePlaceholder") ? .scaleAspectFit : .scaleAspectFill
                    updateCell.posterImageView.image = image
                }
            })
        return cell
    }
    
    
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController.initializeVC()
        vc.movie = self.movieViewModel?.getMovie(from: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
