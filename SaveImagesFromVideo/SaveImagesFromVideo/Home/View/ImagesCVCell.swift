//
//  ImagesCVCell.swift
//  video
//
//  Created by Ahmed Abuelmagd on 22/11/2022.
//

import UIKit

class ImagesCVCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initCell(cellData: UIImage){
        image.image = cellData
        image.clipsToBounds = true
    }
}
