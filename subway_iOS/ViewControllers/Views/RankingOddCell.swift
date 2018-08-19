//
//  RankingOddCell.swift
//  subway_iOS
//
//  Created by Jaeseong on 17/06/2018.
//  Copyright © 2018 TeamSubway. All rights reserved.
//

import UIKit
import Kingfisher


// MARK: - 메인 테이블뷰 셀
class RankingOddCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var oddheight: NSLayoutConstraint!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainNumberLabel: UILabel!
    @IBOutlet weak var mainLikeButton: UIButton!
    @IBOutlet weak var mainBookmarkButton: UIButton!
    @IBOutlet weak var mainShareButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var ingrediendTitle = ["메인 재료","빵 선택", "치즈 선택","추가 선택", "토스팅 여부","야채 선택","소스 선택"]
    
    var ingrediendData = [[Bread]]() {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
//            self.collectionView.setContentOffset(collectionView.contentOffset, animated:false)
            self.collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let flow = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
//        flow?.minimumInteritemSpacing = 10
//        flow?.estimatedItemSize = CGSize(width: 1, height: 1)
        self.collectionView?.isScrollEnabled = false
        
    }
    
    func setData(_ data: [String:Any]) {

        let aa = data["image"] as! Sandwich
        let name = data["name"] as! Name
        self.mainImageView.kf.setImage(with: URL(string: aa.image3XRight))
        self.mainTitleLabel.text = name.name
        self.mainNumberLabel.text = String(name.id)
//        self.collectionView.reloadData()

        
//        self.layoutIfNeeded()
    }
    
    @IBOutlet weak var tableViewHeightCon: NSLayoutConstraint!
    override func prepareForReuse() {
    //        self.ingreTableView.delegate = nil
    //        self.ingreTableView.dataSource = nil
        self.ingrediendData.removeAll()
    }
}
extension RankingOddCell {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.ingrediendData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ingrediendData[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailIngCollCellOdd", for: indexPath) as! RankingOddCollectionCell
        cell.setData(self.ingrediendData[indexPath.section][indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            sectionHeader.sectionTitle.text = ingrediendTitle[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}
class SectionHeader: UICollectionReusableView {
    @IBOutlet weak var sectionTitle: UILabel!
    
}
// MARK: - 컬렉션뷰 셀
class RankingOddCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgaeView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setData(_ data: Bread) {
        self.imgaeView.kf.setImage(with: URL(string: data.image3X))
        self.label.text = data.name
//        self.contentView.setNeedsLayout()
    }
}
