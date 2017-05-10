//
//  AfterSaleViewController.swift
//  legend_business_ios
//
//  Created by Frank on 2016/11/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class AfterSaleViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var myTableView:UITableView!;
    var dataList:Array<SaleAfterModel> = Array()
    var afterSaleStatus:Int!
    var segMent:UISegmentedControl!
    var pageNo = 1
    var totalPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "售后服务"
        self.setBackButton()
        initFrameView() //初始化界面
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func loadData() -> Void {
        let dict = ["device_id":SaveEngine.getDeviceUUID(),
                    "token":SaveEngine.getToken(),
                    "do_status":String.init(format: "%d", self.afterSaleStatus),
                    "page":String.init(format: "%d", self.pageNo)]
        self.showHud(in: self.view, hint: "")
        self.requestHTTPData(self.getHttpUrl("api/After/getSellerAfterList"), parameters:dict, success:{(response:Any) in
            self.myTableView.mj_header.endRefreshing()
            self.hideHud()
            let dic = response as! NSDictionary
            if self.pageNo == 1 {
                self.totalPage = dic["total_page"] as! Int
                self.dataList = SaleAfterModel.parseResponse(response)
            }else {
                let array = SaleAfterModel.parseResponse(response)
                if (array?.count)! > 0 {
                    self.dataList = self.dataList + array!
                }
            }
            self.segMent.setTitle(String.init(format: "进行中（%@）", dic["total_count_do"] as! String), forSegmentAt: 0)
            self.segMent.setTitle(String.init(format: "全部（%@）", dic["total_count_all"] as! String), forSegmentAt: 1)
            self.myTableView.reloadData()
        }, failed:{(errorDic:Any) in
            self.myTableView.mj_header.endRefreshing()
            self.hideHud()
            print(errorDic)
        })
    }
    
    func headerRefreshing() {
        self.pageNo = 1
        self.loadData()
    }
    
    func footerRefreshing() {
        self.myTableView.mj_footer.beginRefreshing()
        if self.pageNo >= self.totalPage {
            self.myTableView.mj_footer.endRefreshing()
            return
        }
        self.pageNo += 1
        self.loadData()
        self.myTableView.mj_footer.endRefreshing()
    }
    
    func clickSegValueChange(seg:UISegmentedControl) -> Void {
        print(seg.selectedSegmentIndex)
        self.afterSaleStatus = seg.selectedSegmentIndex+1
        self.loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSaleTableViewCell") as! AfterSaleTableViewCell
        cell.backgroundColor = self.backgroundColor()
        cell.selectionStyle = .none
        let model:SaleAfterModel = self.dataList[indexPath.row]
        cell.nameBtn.setTitle(model.consignee, for: .normal)
        
        cell.nameLab.text = model.goods_name
        cell.attrLab.text = String.init(format: "规格：%@",model.attr_name)
        cell.priceLab.text = String.init(format: "¥%@", model.price)
        if Int(model.delivery_status) == 1{
            cell.statusLab.text = "买家已发货"
        }
        if Int(model.delivery_status) == 0 {
            cell.statusLab.text = "买家已付款"
        }
        
        guard let status = Int(model.after_status) else {
            return cell
        }
        if status == 1 || status == 3 {
            cell.timerBtn.isHidden = false
            let timeCount:Int = Int(model.end_tiem)! - Int(model.service_time)!
            self.startCountdownTime(timeCount: timeCount, cell: cell)
        }else {
            cell.timerBtn.isHidden = true
        }
        cell.logoIm.sd_setImage(with: URL(myString: (model.goods_thumb)), placeholderImage: UIImage(named:"默认"))
        let completeStatus:Int = Int(model.is_complete)!
        let afterType:Int = Int(model.after_type)!

        switch status {
        case 1,2,3:
            cell.cometeStatus.setTitle("请处理", for: .normal)
        case 4,5,8:
            cell.cometeStatus.setTitle("请处理", for: .normal)
        case 6,9:
            cell.cometeStatus.setTitle("退款关闭", for: .normal)
        default:
            cell.cometeStatus.setTitle("请处理", for: .normal)
        }
        if completeStatus == 1 && status != 6 {
            cell.cometeStatus.setTitle("退款完成", for: .normal)
        }
        if completeStatus == 2 && status == 2 && afterType == 3{
            cell.cometeStatus.setTitle("退款完成", for: .normal)
        }
        if status == 1 && afterType == 3 {
            cell.cometeStatus.setTitle("请退款", for: .normal)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let model = self.dataList[indexPath.row]
        
        if !model.after_id.isEmpty {
            let refundVc = RefundViewController()
            refundVc.after_id = model.after_id
            self.navigationController?.pushViewController(refundVc, animated: true)
        }
    }
    
    func initFrameView() -> Void {
        let titleView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width:self.view.frame.width , height:40))
        titleView.backgroundColor = self.mainColor()
        self.view.addSubview(titleView)
        
        let item = ["进行中","全部"]
        self.segMent = UISegmentedControl.init(items: item)
        self.segMent.frame = CGRect(x: 30, y: (titleView.frame.height-30)/2, width: self.view.frame.width-60, height: 30)
        self.segMent.addTarget(self, action:#selector(clickSegValueChange(seg:)), for: .valueChanged)
        self.segMent.selectedSegmentIndex = 0;
        self.afterSaleStatus = 1;
        self.segMent.tintColor = UIColor.white
        titleView.addSubview(self.segMent)
        
        self.myTableView = UITableView.init(frame: CGRect(x: 0, y: 40, width:self.view.frame.width , height:self.view.frame.height-40-64), style:.plain)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.register(UINib (nibName: "AfterSaleTableViewCell", bundle: nil), forCellReuseIdentifier: "AfterSaleTableViewCell")
        self.myTableView.showsVerticalScrollIndicator = false
        myTableView.separatorColor = self.seperateColor()
        myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.myTableView.estimatedRowHeight = 200;
        self.myTableView.rowHeight = UITableViewAutomaticDimension;
        self.view.addSubview(self.myTableView)
        
        self.myTableView.tableFooterView = UIView()
        
        weak var weakSelf = self;
        
        self.myTableView?.tableFooterView = UIView()
        self.myTableView?.addRefreshHeader({ (header) -> Void in
            weakSelf!.headerRefreshing()
        })
        self.myTableView?.addRefreshFooter({ (footer) -> Void in
            weakSelf?.footerRefreshing()
        })
//        self.myTableView!.mj_header.beginRefreshing()
    }
    
    func startCountdownTime(timeCount:Int,cell:AfterSaleTableViewCell) -> Void {
        let day:Int = timeCount/(24*3600)
        let hour:Int = (timeCount%(24*3600))/3600
        let minutes:Int = (timeCount%3600)/60
        var dayStr:String = String.init(format: "%d", day)
        var hourStr:String = String.init(format: "%d", hour)
        var minutesStr:String = String.init(format: "%d", minutes)
        if day<=0 {
            dayStr = String.init(format: "00")
        }
        if day>=10000 {
            dayStr = String.init(format: "%.1f万",Double(day)/10000)
        }else{
            dayStr = String.init(format: "%d",day)
        }
        if hour<10 && hour > 0{
            hourStr = String.init(format: "0%d", hour)
        }
        if minutes<10 && minutes>0 {
            minutesStr = String.init(format: "0%d", minutes)
        }
        let timeStr:String = String.init(format: "剩%@天%@时%@分", dayStr,hourStr,minutesStr)
        cell.timerBtn.setTitle(timeStr, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
