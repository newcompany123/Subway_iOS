//
//  SearchViewController.swift
//  subway_iOS
//
//  Created by khpark on 2018. 7. 8..
//  Copyright © 2018년 TeamSubway. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchedWordCollectionView: UICollectionView!
    
    var dummyData = [
        "hello", "world", "abc", "lorem ipsum", "dolor sit amet", "consectetur",
        "subway", "delicious", "fast five", "beer", "coffee", "sandwich",
        "apple", "mango", "banana", "grapefruit", "Apink", "red velvet", "twice",
        "lorem ipsum dolor sit amet consectetur asdlkj asdlfkjasdf"
    ]
    
    let lineSpacing : CGFloat = 5
    let collectionViewLeftInset : CGFloat = 20
    let cellPadding : CGFloat = 50 // X button 과 나머지 inset
    
    var originXCache : CGFloat = 0
    var originYCache : CGFloat = -1 // 0부터 시작하기 때문에 -1으로 초기화
    var page = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews(){
        textField.leftViewMode = .always
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        textField.leftView = leftView
        let icon = UIImageView(image: #imageLiteral(resourceName: "iconSearchGrey"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(icon)
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        icon.centerXAnchor.constraint(equalTo: leftView.centerXAnchor, constant: 4).isActive = true
        icon.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        
        searchedWordCollectionView.delegate = self
        searchedWordCollectionView.dataSource = self
        searchedWordCollectionView.reloadData()
    }


}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getRowCount(page: page)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchedWordCell", for: indexPath) as! SearchedWordCell
        cell.data = dummyData[indexPath.item]
        if originYCache != cell.frame.origin.y { // 새로운 row로 진입했을 때
            originXCache = collectionViewLeftInset
            cell.frame.origin.x = collectionViewLeftInset
            originYCache = cell.frame.origin.y
        } else {
            cell.frame.origin.x = originXCache + lineSpacing
        }
        originXCache += lineSpacing + cell.frame.width
        
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteItem(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = NSString(string: dummyData[indexPath.item]).size(withAttributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)]).width + cellPadding
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: collectionViewLeftInset, bottom: 0, right: collectionViewLeftInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "MoreBtnSection", for: indexPath) as! MoreBtnSection
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapFooter))
            footer.clickArea.addGestureRecognizer(tap)
            return footer
        }
        return UICollectionReusableView()
    }
    
    @objc fileprivate func tapFooter(){
        page += 1
        searchedWordCollectionView.reloadData()
    }
    
    @objc fileprivate func deleteItem(sender : UIButton){
        print(sender.tag)
        dummyData.remove(at: sender.tag)
        searchedWordCollectionView.reloadData()
    }
    
    fileprivate func getRowCount(page : Int) -> Int{
        var row = 1 // initial data
        var viewCount = 0
        
        let viewWidth = view.frame.width
        var maxXCache : CGFloat = collectionViewLeftInset
        
        for item in dummyData {
            let width = NSString(string: item).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]).width + cellPadding
            maxXCache += width + lineSpacing
            
            if maxXCache + collectionViewLeftInset > viewWidth {
                row += 1
                maxXCache = collectionViewLeftInset + width + lineSpacing
            }
            
            if row > page * 3 {
                break
            }
            viewCount += 1
        }
        return viewCount
    }
    
    
    
}