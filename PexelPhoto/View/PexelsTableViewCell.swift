//
//  PexelsTableViewCell.swift
//  PexelPhoto
//
//  Created by Jeremy Lee on 10/17/21.
//

import UIKit

class PexelsTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet weak var pexelImage: UIImageView!
    @IBOutlet weak var pexelArtist: UILabel!
    
    //MARK: - Nib Loading
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pexelImage.layer.masksToBounds = true
        pexelImage.layer.cornerRadius = 20.0
        pexelArtist.layer.masksToBounds = true
        pexelArtist.layer.cornerRadius = 15.0
        pexelArtist.layer.backgroundColor = UIColor.darkGray.cgColor
        pexelArtist.layer.borderColor = UIColor.white.cgColor
        pexelArtist.textColor = .white
        pexelArtist.layer.borderWidth = 1.0
        pexelArtist.layer.shadowColor = UIColor.lightGray.cgColor
        pexelArtist.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        pexelArtist.layer.shadowRadius = 15.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
