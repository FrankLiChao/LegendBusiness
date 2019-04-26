//
//  MyIncomeTableController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/22.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class MyIncomeTableController: UITableViewController {

    @IBOutlet var headerView : UIView?
    @IBOutlet var allAvalibleMoneyLabel : UILabel?
    @IBOutlet var cashButton : UIButton?
    @IBOutlet var dealingMoneyLabel : UILabel?//正在交易中的金额
    @IBOutlet var dealedMoneyLabel : UILabel?//已完成的交易金额
    @IBOutlet var bankStatusLabel : UILabel?//银行卡绑定状态

    
    var currentModel : PacketModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView?.frame = CGRect(x: 0, y: 0, width: Configure.SYS_UI_WINSIZE_WIDTH(), height: Configure.SYS_UI_SCALE(185))
        
        allAvalibleMoneyLabel?.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(45))
        cashButton?.titleLabel!.font = UIFont.systemFont(ofSize: Configure.SYS_FONT_SCALE(14))
        
        UitlCommon.setFlat(view: cashButton!, radius: Configure.SYS_CORNERRADIUS(), borderColor: UIColor.white, borderWidth: 1)

        NotificationCenter.default.addObserver(self, selector: #selector(MyIncomeTableController.loadData), name: NSNotification.Name(rawValue: SYS_CASH_SUCESS_NOTIFY), object: nil)
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData(){
        weak var weakSekf = self
        
        self.showHud(in: UIApplication.shared.keyWindow,hint: "")
        self.getMyIncome({ (model ) -> Void in
            
            weakSekf!.hideHud()
            
            weakSekf!.currentModel = model! as PacketModel
            weakSekf!.hideHud()
            if let model = model {
                weakSekf!.allAvalibleMoneyLabel?.text = model.money!
                weakSekf!.dealingMoneyLabel?.text = model.freeze_money!
                weakSekf!.dealedMoneyLabel?.text = model.withdraw_money!
            }
            
            if (model?.is_bundle_card.boolValue)! { weakSekf!.bankStatusLabel?.text = "" }
            else {weakSekf!.bankStatusLabel?.text = "未绑定" }
            
            }, failed: { (msg ) -> Void in
                weakSekf!.hideHud()
                weakSekf!.showHint(msg)
        })
    
    }

    
    @IBAction func clickCashButton(){
    
        let vc = CashViewController(nibName: "CashViewController", bundle: nil)
        if currentModel == nil {
          vc.myMoney = "0"
        }
        else {
          vc.myMoney = currentModel!.money
        }
      
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {return 10}
        return 0
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
