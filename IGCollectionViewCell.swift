//
//  IGCollectionViewCell.swift
//  IGApiApp
//
//  Created by 陳秉軒 on 2022/4/24.
//

import UIKit

class IGCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "\(IGCollectionViewCell.self)"
    @IBOutlet weak var igImageView: UIImageView!
}
