//
//  StoreMainTableViewController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/18.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class StoreMainTableViewController: UITableViewController {
    
    @IBOutlet var headerView : UIView!
    @IBOutlet var storeLogoButton : UIButton!
    @IBOutlet var sellerIDLabel : UILabel!
    @IBOutlet var storeNameLabel : UILabel!
    
    @IBOutlet var incomeTitleLabel : UILabel!
    @IBOutlet var incomeLabel : UILabel!
    @IBOutlet var orderTitleLabel : UILabel!
    @IBOutlet var orderNumLabel : UILabel!
    
    @IBOutlet var logoHeight : NSLayoutConstraint!
    @IBOutlet var icomeBarHeight : NSLayoutConstraint!
    @IBOutlet weak var alertImg: UIImageView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UitlCommon.setFlat(view: storeLogoButton!, radius: logoHeight!.constant/2, borderColor: UIColor.white, borderWidth:3.0)
        
        incomeTitleLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(13))
        orderTitleLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(13))
        incomeLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(16))
        orderNumLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(16))
        sellerIDLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(13))
        storeNameLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(16))
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(StoreMainTableViewController.updateUserInfo(_:)),
                                               name: NSNotification.Name(rawValue: SYS_NOTI_USERINFO_UPDATE),
                                               object: nil)
        
        weak var weakSelf = self
        tableView?.addRefreshHeader({ (header) -> Void in
            weakSelf!.getUserInfo({ (userInfo) -> Void in
                weakSelf!.updateUserInfo(nil)
                weakSelf!.tableView.mj_header.endRefreshing()
            }, failed: { (errorDes) -> Void in
                weakSelf!.tableView.mj_header.endRefreshing()
                weakSelf!.showHint(errorDes)
            });
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        updateUserInfo(nil);
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Custom method
    @IBAction func clickSetting(){
        let story : UIStoryboard = UIStoryboard(name: "Setting", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "SettingController") as!  SettingController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Notify
    func updateUserInfo(_ notify: Notification?){
        let userInfo = SaveEngine.getUserInfo()
        if  userInfo != nil {
            storeLogoButton?.sd_setBackgroundImage(with: URL(string: (userInfo?.thumb_img)!), for: UIControlState(), placeholderImage: UIImage(named: "默认"))
            self.storeNameLabel?.text = userInfo!.seller_name
            self.sellerIDLabel?.text = userInfo!.seller_id
            self.incomeLabel?.text = "¥" + "\((userInfo?.today_money)!)"
            if  userInfo!.today_total_order == nil {
                self.orderNumLabel?.text = "0"
            } else {
                self.orderNumLabel?.text = "\((userInfo?.today_total_order)!)"
            }
            self.alertImg.isHidden = !userInfo!.is_warning
        }
    }

    @IBAction func weekBonusClicked(_ sender: UIButton) {
        let week = WeekBonusViewController()
        let _ = self.navigationController?.pushViewController(week, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  Configure.SYS_UI_SCALE(130)
    
    }
    

}
