//
//  DetailTableViewCell.swift
//  IGApiApp
//
//  Created by 陳秉軒 on 2022/5/2.
//

import UIKit
import AVFoundation
import AVKit

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var videoViewCountLabel: UILabel!
    
    @IBOutlet weak var postCaptionLabel: UILabel!
    
    @IBOutlet weak var postCommentLabel: UILabel!
    
    
    @IBOutlet weak var timeLamel: UILabel!
    
    var likeButtonStatus: Bool = false
    @IBAction func like(_ sender: UIButton) {
        likeButtonStatus = !likeButtonStatus
         if likeButtonStatus {
             likeButton.setImage(UIImage(named: "iconRedLove"), for: UIControl.State.normal)
         }
         else {
             likeButton.setImage(UIImage(named: "iconLove"), for: UIControl.State.normal)
         }
    }
    
    
    
    
    
    
    
    
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
