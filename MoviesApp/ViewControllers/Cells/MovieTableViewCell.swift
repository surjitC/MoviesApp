//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    static let cellId = "MovieTableViewCell"
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(for movie: MovieModel?) {
        self.titleLabel.text = movie?.title
        self.languageLabel.text = movie?.language
        self.yearLabel.text = movie?.year
    }

}
