//
//  MovieDefaultTableViewCell.swift
//  MoviesApp
//
//  Created by Surjit on 14/03/21.
//

import UIKit

class MovieDefaultTableViewCell: UITableViewCell {

    static let cellId = "MovieDefaultTableViewCell"
    @IBOutlet var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
