//
//  GoodsImagesTableViewCell.swift
//  legend_business_ios
//
//  Created by Tsz on 2016/11/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

protocol GoodsImagesTableViewCellDelegate {
    func goodsImagesTableViewCell(_ cell: GoodsImagesTableViewCell, didTappedDeleteBtnAt index: Int)
    func goodsImagesTableViewCell(_ cell: GoodsImagesTableViewCell, didTappedImageAt index: Int)
}

class GoodsImagesTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    weak var line: UIImageView!
    var delegate: GoodsImagesTableViewCellDelegate?
    
    var fetchDataSource: () -> [UIImage] = { return [] }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let line = UIImageView()
        self.line = line
        self.line.backgroundColor = Configure.SYS_UI_COLOR_LINE_COLOR()
        self.addSubview(self.line)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.line.frame = CGRect(x: 15, y: self.contentView.frame.maxY, width: self.bounds.width - 30, height: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Custom
    @objc func handleDeleteBtnEvent(_ sender: UIButton) {
        let index = sender.tag
        self.delegate?.goodsImagesTableViewCell(self, didTappedDeleteBtnAt: index)
    }
    
    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let images = fetchDataSource()
        return min(images.count + 1, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let images = fetchDataSource()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodsImagesCollectionViewCell", for: indexPath) as! GoodsImagesCollectionViewCell
        
        if indexPath.row >= images.count {
            cell.imageView.image = UIImage(named: "add_goods_img")
            cell.deleteBtn.isHidden = true
            cell.progressView.isHidden = true
        } else {
            cell.imageView.image = images[indexPath.row]
            cell.deleteBtn.isHidden = false
            cell.progressView.isHidden = true
        }
        cell.deleteBtn.tag = indexPath.row;
        cell.deleteBtn.addTarget(self, action: #selector(handleDeleteBtnEvent(_:)), for: .touchUpInside)
        cell.currentIndex = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.delegate?.goodsImagesTableViewCell(self, didTappedImageAt: indexPath.row)
    }

}


class GoodsImagesCollectionViewCell: UICollectionViewCell {
    var currentIndex: Int?
    
    weak var imageView: UIImageView!
    weak var deleteBtn: UIButton!
    weak var progressView: TKPieProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView = UIImageView()
        self.imageView = imageView
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
        
        let deleteBtn = UIButton(type: .custom)
        self.deleteBtn = deleteBtn
        self.deleteBtn.setBackgroundImage(UIImage(named: "Delete"), for: .normal)
        self.addSubview(self.deleteBtn)
        
        let progressView = TKPieProgressView(frame: CGRect(x: 0, y: 0, width: 30, height:30))
        self.progressView = progressView
        self.progressView.pieInset = 1.5;
        self.progressView.hidesWhenFinished = true
        self.addSubview(self.progressView)
        
        let name = Notification.Name(rawValue : "GoodsImagesCollectionViewCell.Progress")
        NotificationCenter.default.addObserver(self, selector: #selector(handleProgresChanged(_:)), name: name, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let imageView = UIImageView()
        self.imageView = imageView
        self.imageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.imageView)
        
        let deleteBtn = UIButton(type: .custom)
        self.deleteBtn = deleteBtn
        self.deleteBtn.setBackgroundImage(UIImage(named: "Delete"), for: .normal)
        self.contentView.addSubview(self.deleteBtn)
        
        let progressView = TKPieProgressView(frame: CGRect(x: 0, y: 0, width: 30, height:30))
        self.progressView = progressView
        self.progressView.pieInset = 1.5;
        self.addSubview(self.progressView)
        
        let name = Notification.Name(rawValue : "GoodsImagesCollectionViewCell.Progress")
        NotificationCenter.default.addObserver(self, selector: #selector(handleProgresChanged(_:)), name: name, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.frame = self.contentView.bounds
        self.deleteBtn.frame = CGRect(x: self.bounds.width - 20, y: 0, width: 20, height: 20)
        self.progressView.frame = CGRect(x: (self.bounds.width - 30)/2, y: (self.bounds.height - 30)/2, width: 15, height: 15)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Custom
    @objc func handleProgresChanged(_ noti: Notification) {
        if let userInfo = noti.userInfo {
            if let index = userInfo["index"] as? Int {
                if index == self.currentIndex {
                    let progress = noti.object as! Progress
                    print("\(progress.fractionCompleted)")
                    DispatchQueue.main.async {
                        if progress.fractionCompleted != 1.0 {
                            self.progressView.isHidden = false
                            self.progressView.setProgressWithAnimation(progress.fractionCompleted)
                        } else {
                            self.progressView.setProgressWithAnimation(0.9999)
                            self.progressView.isHidden = false
                            let time: TimeInterval = 0.5
                            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: delay, execute: { 
                                self.progressView.isHidden = true
                            })
                        }
                    }
                }
            }
        }
    }
}
