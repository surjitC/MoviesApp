//
//  MovieRatingTableViewCell.swift
//  MoviesApp
//
//  Created by Surjit on 14/03/21.
//

import UIKit

class MovieRatingTableViewCell: UITableViewCell {

    static let cellId = "MovieRatingTableViewCell"
    
    @IBOutlet var ratingSource: UISegmentedControl!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var ratingValueLabel: UILabel!
    @IBOutlet var ratingSourceImageView: UIImageView!
    @IBOutlet var ratingSourceNameLabel: UILabel!
    
    var ratings: [Rating] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(for ratings: [Rating]) {
        self.ratings = ratings
        let ratingNames = self.ratings.compactMap({ $0.source == .internetMovieDatabase ? "IMDb" : $0.source?.rawValue })
        self.ratingSource.replaceSegments(segments: ratingNames)
        self.ratingSource.selectedSegmentIndex = 0
        let rating = self.ratings[0]
        self.setData(for: rating)
    }
    @IBAction func sourceSwitched(_ sender: UISegmentedControl) {
        let rating = self.ratings[sender.selectedSegmentIndex]
        self.setData(for: rating)
    }
    
    func setData(for rating: Rating?) {
        self.ratingValueLabel.text = rating?.value
        self.ratingSourceNameLabel.text = rating?.source?.rawValue
        switch rating?.source {
        case .internetMovieDatabase:
            self.ratingSourceImageView.image = #imageLiteral(resourceName: "imdb")
            if let values = rating?.value?.components(separatedBy: "/"), let firstValueString = values.first, let firstValue = Float(firstValueString) {
                self.ratingControl.currentRating = CGFloat(firstValue * 5 / 10)
            }
        case .rottenTomatoes:
            self.ratingSourceImageView.image = #imageLiteral(resourceName: "rottentomatoes")
        if let values = rating?.value?.components(separatedBy: "%"), let firstValueString = values.first, let firstValue = Float(firstValueString) {
            self.ratingControl.currentRating = CGFloat(firstValue * 5 / 100)
        }
        case .metacritic:
            self.ratingSourceImageView.image = #imageLiteral(resourceName: "Metacritic")
        if let values = rating?.value?.components(separatedBy: "/"), let firstValueString = values.first, let firstValue = Float(firstValueString) {
            self.ratingControl.currentRating = CGFloat(firstValue * 5 / 100)
        }
        default:
            self.ratingControl.currentRating = 0
        }
    }
    
}

extension UISegmentedControl {
    func replaceSegments(segments: [String]) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
