//
//  IncomeListController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/22.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class IncomeListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView : UITableView?
    
    
    var dataList = NSMutableArray()
    
    
    deinit {
        
        print("IncomeListController 释放")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setBackButton()
        self.title = "收入记录"
        
        weak var weakSelf = self;
        
        tableView?.rowHeight = Configure.SYS_UI_SCALE(70)
        tableView?.tableFooterView = UIView()
        tableView?.addRefreshHeader({ (header) -> Void in
            
            if weakSelf!.tableView!.mj_footer.isRefreshing() {
                
                weakSelf!.tableView!.mj_header.endRefreshing()
            }
            else{
                weakSelf!.refreshData()
            }
            
        })
        
        tableView?.addRefreshFooter({ (footer) -> Void in
            
            if weakSelf!.tableView!.mj_header.isRefreshing() {
                
                weakSelf!.tableView!.mj_footer.endRefreshing()
            }
            else{
                
                weakSelf?.loadMoreData()
            }
            
        })
        
        tableView!.mj_header.beginRefreshing()
        
    }
    
    func refreshData(){
        
        
        weak var weakSelf = self
        
        self.getMyIncomeList("0", success: { (list:[CashHistoryModel]?,count: Int32) -> Void in
            if let list = list {
                weakSelf!.dataList = NSMutableArray(array: list)
            }
            weakSelf!.tableView?.reloadData()
            weakSelf!.tableView?.mj_header.endRefreshing()
            if count < 20 {
                weakSelf!.tableView?.mj_footer.setExtensionStatus(MJExtensionStatus_NoMoreData)
            }
            }, failed: {(msg) -> Void in
                weakSelf!.tableView?.mj_header.endRefreshing()
                weakSelf!.showHint(msg)
        })
    }
    
    func loadMoreData(){
        
        let listModel = dataList.lastObject as! CashHistoryModel
        
        let model = (listModel.list as NSArray).lastObject
        
        weak var weakSelf = self
        
        self.getMyIncomeList((model! as AnyObject).order_id, success: { (list:[CashHistoryModel]?,count: Int32) -> Void in
            
            if let list = list {
                weakSelf!.dataList.addObjects(from: list)
            }
            weakSelf!.tableView?.reloadData()
            weakSelf!.tableView?.mj_footer.endRefreshing()
            
            if count < 20 {
                
                weakSelf!.tableView?.mj_footer.setExtensionStatus(MJExtensionStatus_NoMoreData)
            }
            }, failed: {(msg) -> Void in
                
                weakSelf!.tableView?.mj_footer.endRefreshing()
                weakSelf!.showHint(msg)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
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
        let lable = InsetsLabel(frame:CGRect(x: 0,y: 0,width: Configure.SYS_UI_WINSIZE_WIDTH(),height: 30), insets: UIEdgeInsetsMake(0, 10, 0, 0))
        lable.backgroundColor = Configure.SYS_UI_COLOR_BG_COLOR()
        lable.font = UIFont.systemFont(ofSize: Configure.SYS_UI_SCALE(15))
        lable.textColor = Configure.SYS_UI_COLOR_TEXT_GRAY()
        lable.text = model.monthStr()
        return lable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealingListCell") as! DealingListCell
        let listModel = dataList.object(at: indexPath.section) as! CashHistoryModel
        let model = (listModel.list as NSArray).object(at: indexPath.row) as! CashModel
        cell.dataLabel?.attributedText = model.createTimeStr()
        cell.headImageView?.sd_setImage(with: URL(myString: model.user_avatar!) ,placeholderImage: UIImage(named: "默认"))
        cell.priceLabel?.text = "+" + "\(model.goods_amount!)"
        cell.infoLabel?.text = "\(model.goods_name!)"
        return cell
    }
}
