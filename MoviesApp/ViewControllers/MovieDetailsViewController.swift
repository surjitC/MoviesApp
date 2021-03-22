//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case Title
        case Rating
        case Description
        case Director
        case Genre
        case Actor
    }

    class func initializeVC() -> MovieDetailsViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as?  MovieDetailsViewController else {
            return MovieDetailsViewController()
        }
        return vc
    }
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var movieDetailTableView: UITableView!
    
    var movie: MovieModel?
    var headerTitle: String?
    var imageDownloader = ImageDownloader()
    var kTableHeaderHeight: CGFloat = 300.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setupHeaderView() {
        kTableHeaderHeight = self.view.frame.width * 2.5 / 2
        
        headerView = movieDetailTableView.tableHeaderView
        movieDetailTableView.tableHeaderView = nil
        movieDetailTableView.addSubview(headerView)
        movieDetailTableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        movieDetailTableView.contentOffset = CGPoint(x: 0, y: 0)//-kTableHeaderHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupHeaderView()
        
        imageDownloader.loadImage(from: movie?.poster) { [weak self] image in
            self?.headerImageView.contentMode = .scaleAspectFill
            self?.headerImageView.image = image
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: movieDetailTableView.bounds.width, height: kTableHeaderHeight)
         if movieDetailTableView.contentOffset.y < 0 {
                    headerRect.origin.y = movieDetailTableView.contentOffset.y
                    headerRect.size.height = -movieDetailTableView.contentOffset.y
               
         }
                
        headerView.frame = headerRect
    }
}

extension MovieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.row) {
        case .Title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTitleTableViewCell.cellId, for: indexPath) as? MovieTitleTableViewCell else {
                preconditionFailure("Failed to load movie title cell")
            }
            cell.configureCell(for: self.movie)
            return cell
        case .Description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDescriptionTableViewCell.cellId, for: indexPath) as? MovieDescriptionTableViewCell else {
                preconditionFailure("Failed to load movie description cell")
            }
            cell.descriptionLabel.text = movie?.plot
            return cell
        case .Director:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDefaultTableViewCell.cellId, for: indexPath) as? MovieDefaultTableViewCell else {
                preconditionFailure("Failed to load movie description cell")
            }
            cell.detailLabel?.text = "Director : \(movie?.director ?? "")"
            return cell
        case .Genre:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDefaultTableViewCell.cellId, for: indexPath) as? MovieDefaultTableViewCell else {
                preconditionFailure("Failed to load movie description cell")
            }
            cell.detailLabel?.text = "Genre : \(movie?.genre ?? "")"
            return cell
        case .Actor:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDefaultTableViewCell.cellId, for: indexPath) as? MovieDefaultTableViewCell else {
                preconditionFailure("Failed to load movie description cell")
            }
            cell.detailLabel?.text = "Actors : \(movie?.actors ?? "")"
            return cell
        case .Rating:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieRatingTableViewCell.cellId, for: indexPath) as? MovieRatingTableViewCell else {
                preconditionFailure("Failed to load movie description cell")
            }
            if let rating = movie?.ratings {
                cell.configureCell(for: rating)
            }
            return cell
        default:
            preconditionFailure("Failed to load movie default cell")
        }
    }
    
}

extension MovieDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
