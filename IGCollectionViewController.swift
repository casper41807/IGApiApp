//
//  IGCollectionViewController.swift
//  IGApiApp
//
//  Created by 陳秉軒 on 2022/4/24.
//

import UIKit

//private let reuseIdentifier = "\(IGCollectionViewCell.self)"

class IGCollectionViewController: UICollectionViewController{

    var igArrays:[Instagram] = []
    let princes: [Instagram] = {
            var princes = [Instagram]()
            for i in 0...10 {
                let prince = Instagram(name: "賭神\(i)號", image: "pic\(i)")
                princes.append(prince)
            }
            return princes
        }()
    
    
    var userInfo:InstagramResponse?
    var postImages = [InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createArray()
        configureCellSize()
        //轉向＆使用 view controller + collection view 解法
        //configureCellSize(collectionViewWidth: UIScreen.main.bounds.width)
        
        fetchItem()
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center //置中
        label.textColor = .white
        let userNameUpper = userInfo?.graphql.user.username
        label.text = "\(userNameUpper ?? "thesimpsons")"
        navigationItem.titleView = label
        
        navigationItem.backButtonTitle = ""
//        navigationController?.title = "thesimpsons"
//        navigationController?.navigationBar.barTintColor = .white
        
    }
    
    func createArray(){
        for i in 0...10{
            igArrays.append(Instagram(name: "賭神\(i)號", image: "pic\(i)"))
        }
    }
    
    
    func fetchItem(){
        let urlString = "https://www.instagram.com/thesimpsons/?__a=1"
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                if let data = data {
                    do {
                        let instagramResponse = try decoder.decode(InstagramResponse.self, from: data)
                        self.userInfo = instagramResponse
                        self.postImages = instagramResponse.graphql.user.edge_owner_to_timeline_media.edges
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    

    //轉向＆使用 view controller + collection view 解法
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
           configureCellSize(collectionViewWidth: size.width)
       }
       //轉向＆使用 view controller + collection view 解法
    func configureCellSize(collectionViewWidth: CGFloat) {
        let itemSpace: Double = 1
        //3張照片
        let columnCount: Double = 3
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionViewWidth - itemSpace * (columnCount-1)) / columnCount)
        layout?.itemSize = CGSize(width: width, height: width)
        layout?.estimatedItemSize = .zero
        layout?.minimumInteritemSpacing = itemSpace
        layout?.minimumLineSpacing = itemSpace
    }
    func configureCellSize() {
            //間距距離
            let itemSpace: Double = 1
            //3張照片
            let columnCount: Double = 3
            let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
            //寬度會是 collectionView寬度 - ((間隔*幾張圖片-1)/幾張圖片)
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount)
            flowLayout?.itemSize = CGSize(width: width, height: width)
            //將 estimatedItemSize 設為 .zero，如此 cell 的尺寸才會依據 itemSize，否則它將從 auto layout 的條件計算 cell 的尺寸
            flowLayout?.estimatedItemSize = .zero
            flowLayout?.minimumInteritemSpacing = itemSpace
            flowLayout?.minimumLineSpacing = itemSpace
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailTableViewController,let item = collectionView.indexPathsForSelectedItems?.first?.row{
            controller.detail = userInfo
            controller.row = item
            controller.postsDetail = postImages
        }
    }
    
    
    

  

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return postImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:IGCollectionViewCell.reuseIdentifier, for: indexPath) as? IGCollectionViewCell else { return UICollectionViewCell() }
        let item = postImages[indexPath.item]
        //fetch Images (PhotoWall)
        URLSession.shared.dataTask(with: item.node.display_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.igImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "IGCollectionReusableView", for: indexPath) as? IGCollectionReusableView else{return UICollectionReusableView()}
        if let url = userInfo?.graphql.user.profile_pic_url{
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.profilePicUrlImage.layer.cornerRadius = cell.profilePicUrlImage.frame.height/2
                        cell.profilePicUrlImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        cell.postsCountLabel.text = "\(userInfo?.graphql.user.edge_owner_to_timeline_media.count ?? 0)"
        cell.followByLabel.text = "\(userInfo?.graphql.user.edge_followed_by.count ?? 0)"
        cell.follewLabel.text = "\(userInfo?.graphql.user.edge_follow.count ?? 0)"
        cell.fullNameLabel.text = userInfo?.graphql.user.full_name
        cell.biographyLabel.text = userInfo?.graphql.user.biography
        cell.externalLamel.text = userInfo?.graphql.user.external_url
        return cell
    }
    
   
}




//程式產生image，滑動後 profile tab 卡在上方的效果
//let profileImageView = UIImageView(image: UIImage(named: "top"))
//profileImageView.translatesAutoresizingMaskIntoConstraints = false
//collectionView.addSubview(profileImageView)
//
//profileImageView.heightAnchor.constraint(equalToConstant: 413).isActive = true
//profileImageView.leadingAnchor.constraint(equalTo: collectionView.frameLayoutGuide.leadingAnchor).isActive = true
//profileImageView.trailingAnchor.constraint(equalTo: collectionView.frameLayoutGuide.trailingAnchor).isActive = true
//let topConstraint = profileImageView.topAnchor.constraint(equalTo: collectionView.contentLayoutGuide.topAnchor)
//topConstraint.priority = UILayoutPriority(999)
//topConstraint.isActive = true
//profileImageView.bottomAnchor.constraint(greaterThanOrEqualTo: collectionView.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
