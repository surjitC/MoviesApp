//
//  MovieDescriptionTableViewCell.swift
//  MoviesApp
//
//  Created by Surjit on 14/03/21.
//

import UIKit

class MovieDescriptionTableViewCell: UITableViewCell {

    static let cellId = "MovieDescriptionTableViewCell"
    
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
