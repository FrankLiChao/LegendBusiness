//
//  CashedViewController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/22.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class CashedViewHistoryController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView?
    
    
    var dataList = NSMutableArray()
    
    
    deinit {
        
        print("CashedViewController 释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton()
        self.title = "提现记录"
        
        
        
        tableView?.tableFooterView = UIView()
        weak var weakSelf = self;
        
        tableView?.tableFooterView = UIView()
        tableView?.addRefreshHeader({ (header) -> Void in
            if weakSelf!.tableView!.mj_footer.isRefreshing() {
                weakSelf!.tableView!.mj_header.endRefreshing()
            } else {
                weakSelf!.refreshData()
            }
        })
        
        tableView?.addRefreshFooter({ (footer) -> Void in
            if weakSelf!.tableView!.mj_header.isRefreshing() {
                weakSelf!.tableView!.mj_footer.endRefreshing()
            } else {
                weakSelf?.loadMoreData()
            }
        })
        
        tableView!.mj_header.beginRefreshing()
    }
    
    
    
    func refreshData(){
        weak var weakSelf = self;
        self.getCashHistory("0",success:{ (array:[CashHistoryModel]?, count: Int32) in
            weakSelf!.dataList = NSMutableArray(array: array ?? [])
            if count < 20 {
                weakSelf!.tableView?.mj_footer.setExtensionStatus(MJExtensionStatus_NoMoreData)
            }
            weakSelf!.tableView?.reloadData()
            weakSelf!.tableView?.mj_header.endRefreshing()
        },failed:{ (failedStr: String?) in
            weakSelf!.tableView?.mj_header.endRefreshing()
            weakSelf!.showHint(failedStr ?? "请求失败")
        })
    }
    
    func loadMoreData(){
        weak var weakSelf = self;
        let lastModel  = self.dataList.lastObject as! CashHistoryModel
        let array = lastModel.list as NSArray
        let  model = array.lastObject as! CashModel
        
        self.getCashHistory(model.withdraw_id,success:{ (array:[CashHistoryModel]?, count: Int32) in
            self.dataList.addObjects(from: array ?? [])
            self.tableView?.reloadData()
            self.tableView?.mj_footer.endRefreshing()
            if count < 20 {
                weakSelf!.tableView?.mj_footer.setExtensionStatus(MJExtensionStatus_NoMoreData)
            }
            weakSelf!.tableView?.reloadData()
            weakSelf!.tableView?.mj_header.endRefreshing()
        },failed:{(failedStr: String?) in
            weakSelf!.tableView?.mj_footer.endRefreshing()
            weakSelf!.showHint(failedStr ?? "请求失败")
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataList.object(at: section) as! CashHistoryModel
        return model.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            let model = dataList.object(at: section) as! CashHistoryModel
            let lastmodel = dataList.object(at: section - 1) as! CashHistoryModel
            if let str = model.monthStr() as String?, let lastStr = lastmodel.monthStr() as String?, str == lastStr {
                return 0
            }
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataList.object(at: section) as! CashHistoryModel
        let lable = InsetsLabel(frame:CGRect(x:0,y:0,width:Configure.SYS_UI_WINSIZE_WIDTH(),height:30), insets: UIEdgeInsets(top:0, left:10, bottom:0, right:0))
        lable.backgroundColor = Configure.SYS_UI_COLOR_BG_COLOR()
        lable.font = UIFont.systemFont(ofSize: Configure.SYS_UI_SCALE(15))
        lable.textColor = Configure.SYS_UI_COLOR_TEXT_GRAY()
        lable.text = model.monthStr()
        return lable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"DealingListCell") as! DealingListCell
        let listModel: CashHistoryModel = dataList.object(at:indexPath.section) as! CashHistoryModel
        let model: CashModel = (listModel.list as NSArray).object(at:indexPath.row) as! CashModel
        cell.dataLabel?.attributedText = model.applyTimeStr()
        cell.headImageView?.sd_setImage(with: URL(myString: model.logo!), placeholderImage: UIImage(named: "bank_0"))
        cell.priceLabel?.text = "+" + "\(model.money!)"
        if model.cashStatus() == CashStatusType_Doing {
            cell.statusLabel?.isHidden = false
            cell.statusLabel?.textColor = UitlCommon.UIColorFromRGB(0xff9c00)
            cell.statusLabel?.text = "提现中"
        } else if model.cashStatus() == CashStatusType_Failed {
            cell.statusLabel?.isHidden = false
            cell.statusLabel?.textColor = Configure.SYS_UI_COLOR_BG_RED()
            cell.statusLabel?.text = "提现失败"
        } else {
            cell.statusLabel?.isHidden = true
        }
        return cell
    }
}
