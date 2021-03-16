//
//  MovieTitleTableViewCell.swift
//  MoviesApp
//
//  Created by Surjit on 14/03/21.
//

import UIKit

class MovieTitleTableViewCell: UITableViewCell {

    static let cellId = "MovieTitleTableViewCell"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
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
        var detail = ""
        
        if let runtime = movie?.runtime {
            detail = runtime
        }
        if let year = movie?.year {
            detail  += " | \(year)"
        }
        
        self.detailLabel.text = detail
    }
}
