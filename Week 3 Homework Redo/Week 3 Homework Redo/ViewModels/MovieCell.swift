//
//  MovieCell.swift
//  Week3Homework
//
//  Created by Field Employee on 28/08/2021.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"

    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!

//    @IBAction func showDetailsButton(_ sender: Any) {
//
//        let vc = storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
//        vc.titleLabel.text = movieTitleLabel.text
//        vc.descriptionLabel.text = movieOverviewLabel
//        present(vc, animated: true)
//    }
    
    func configureCell(title: String?, overview: String?, imageData: Data?)
    {
        movieOverviewLabel.sizeToFit()
        movieTitleLabel.text = title
        movieOverviewLabel.text = overview
        movieImageView.image = nil
        
        if let data = imageData {
            movieImageView.image = UIImage(data: data)
        }
    }
    
    func getHeight(text:String?, font:UIFont, width:CGFloat) -> CGFloat {
        let myLabel:UILabel = UILabel(frame: CGRect(x: 103, y: 33, width: width, height: CGFloat.greatestFiniteMagnitude))
        myLabel.numberOfLines = 0
        myLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        myLabel.font = font
        myLabel.text = text

        myLabel.sizeToFit()
        
        return myLabel.bounds.size.height
    }
}
