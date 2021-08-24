//
//  ImageCell.swift
//  FlickrSearch
//  A subclass of UICollectionViewCell - we only show images
//  but could show a title too although these are often very long.
//  Created by jonathan ide on 22/8/21.
//

import Foundation
import UIKit

public class ImageCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel?
    
    /// This is important.
    public override func prepareForReuse() {
        super.prepareForReuse()
        /// Essential - we need to clear cell content subviews
        /// because of cell reuse - if not done multiple content (images) will be overlaid
        /// on top
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
    }
 
}
