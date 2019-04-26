//
//  GoodListCell.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

@objc protocol GoodListCellDelegate {
    func goodsListCellTapEditBtn(cell: GoodListCell)
    func goodsListCellTapUpBtn(cell: GoodListCell)
    func goodsListCellTapDownBtn(cell: GoodListCell)
    func goodsListCellTapPromoteBtn(cell: GoodListCell)
    func goodsListCellTapDeleteBtn(cell: GoodListCell)
}

class GoodListCell: UITableViewCell {

    @IBOutlet var iconImageView : UIImageView?
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var priceLabel :UILabel?
    @IBOutlet var stockLabel :UILabel?
    @IBOutlet var sellCountLabel :UILabel?
    @IBOutlet var preSaleLabel :UILabel?
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var promoteBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @objc var delegate: GoodListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        
        self.editBtn.addTarget(self, action: #selector(handleEditEvent(_:)), for: .touchUpInside)
        self.downBtn.addTarget(self, action: #selector(handleDownEvent(_:)), for: .touchUpInside)
        self.promoteBtn.addTarget(self, action: #selector(handlePromoteEvent(_:)), for: .touchUpInside)
        self.deleteBtn.addTarget(self, action: #selector(handleDeleteEvent(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handleEditEvent(_ sender: UIButton) {
        self.delegate?.goodsListCellTapEditBtn(cell: self)
    }
    
    @objc func handleDownEvent(_ sender: UIButton) {
        if sender.currentTitle == "下架" {
            self.delegate?.goodsListCellTapDownBtn(cell: self)
        } else if sender.currentTitle == "上架" {
            self.delegate?.goodsListCellTapUpBtn(cell: self)
        }
    }
    
    @objc func handlePromoteEvent(_ sender: UIButton) {
        self.delegate?.goodsListCellTapPromoteBtn(cell: self)
    }
    
    @objc func handleDeleteEvent(_ sender: UIButton) {
        self.delegate?.goodsListCellTapDeleteBtn(cell: self)
    }
}
