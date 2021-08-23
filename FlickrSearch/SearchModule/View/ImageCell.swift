//
//  ImageCell.swift
//  FlickrSearch
//
//  Created by jonathan ide on 22/8/21.
//

import Foundation
import UIKit


public class ImageCell : UICollectionViewCell {
    
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var imageView  : UIImageView!
    @IBOutlet var titleLabel : UILabel!
}
