//
//  DetailTableViewController.swift
//  IGApiApp
//
//  Created by 陳秉軒 on 2022/5/2.
//

import UIKit
import AVKit
import AVFoundation


class DetailTableViewController: UITableViewController {

    var detail:InstagramResponse!
    var row:Int = 0
    var postsDetail = [InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    var isShow = false
    var like = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center //置中
        label.textColor = .white
        let userNameUpper = detail.graphql.user.username.uppercased()
        label.text = "\(userNameUpper)\n 貼文"
        navigationItem.titleView = label
        
        navigationItem.backButtonTitle = ""
    }
    
    //自動跳到點選cell之文章
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShow == false {
            tableView.scrollToRow(at: IndexPath(item: row, section: 0), at: .top, animated: false)
            isShow = true
        }
    }
    
//    @IBAction func likeButton(_ sender: UIButton) {
//        let point = sender.convert(CGPoint.zero, to: tableView)
//        if let indexPath = tableView.indexPathForRow(at: point){
//
//        }
//    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsDetail.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else{return UITableViewCell() }
        URLSession.shared.dataTask(with: detail.graphql.user.profile_pic_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.userImage.layer.cornerRadius = cell.userImage.frame.width/2
                    cell.userImage.image = UIImage(data: data)
                }
            }
        }.resume()
        
        
        
        
        
        let index = postsDetail[indexPath.row]
        
        URLSession.shared.dataTask(with: index.node.display_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.postImage.image = UIImage(data: data)
                }
            }
        }.resume()
        
//        cell.player = AVPlayer(url: index.node.video_url)
//        cell.playerLayer = AVPlayerLayer(player: cell.player)
//        cell.playerLayer.frame = cell.userImage.frame
//        cell.layer.addSublayer(cell.playerLayer)
//        cell.player.play()
        
        
        
        
        
        cell.videoViewCountLabel.text = "\(index.node.video_view_count)位觀眾"
        cell.postCaptionLabel.text = index.node.edge_media_to_caption.edges[0].node.text
        cell.postCommentLabel.text = "\(index.node.edge_media_to_comment.count)則留言"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let timeText = formatter.string(from: index.node.taken_at_timestamp)
        cell.timeLamel.text = timeText
        cell.userNameLabel.text = detail.graphql.user.username
        
        
        
        
//        cell.likeButtonStatus = false
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
