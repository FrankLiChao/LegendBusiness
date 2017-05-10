//
//  BindBankCardListController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/22.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class BindBankCardListController: BaseViewController,AddBankTableControllerDelegate,BankListCellDelegate {
    
    @IBOutlet var tableView : UITableView?
    @IBOutlet var footButton  : UIButton?
    
    
    var dataList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton()
        self.title = "银行卡"
        
        UitlCommon.setDashedFlat(view: footButton!,radius: Configure.SYS_CORNERRADIUS(),borderColor: Configure.SYS_UI_COLOR_TEXT_GRAY(), borderWidth: 1, bounds: CGRect(x: 0,y: 0,width: Configure.SYS_UI_WINSIZE_WIDTH() - 20,height: 55))
        
        self.loadMyBankList()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddBankSeguePush" {
            
            let vc = segue.destination as! AddBankCardController
            vc.delegate = self
            
        }
    }
    
    
    func loadMyBankList(){
        
        
        self.showHud(in: self.view,hint:"")
        weak var weakSelf = self
        self.getMyBankCardList({(modelList) -> Void in
            weakSelf!.hideHud()
            if modelList != nil{
                
                weakSelf!.dataList = NSMutableArray(array: modelList!)
                
                weakSelf!.tableView?.reloadData()
            }
            
            },failed:{(msg) -> Void in
                weakSelf!.hideHud()
                weakSelf!.showHint(msg)
        })
        
    }
    
    
    
    //MARK: -AddBankTableControllerDelegate
    
    func bindCardSuccess(_ model: MyBankListVO?){
        
        self.loadMyBankList()
        
    }
    
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return dataList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankListCell") as! BankListCell
        cell.selectionStyle = .none
        
        cell.delegate = self
        let cashVO = dataList.object(at: indexPath.row) as! MyBankListVO
        
        cell.bankNameLabel?.text = cashVO.bank_name
        cell.cardDetailLabel?.text = cashVO.card_num + cashVO.card_type
        cell.index = indexPath
        
        if cashVO.bank_logo == nil {
            
            cell.iconImageView?.image = UIImage(named: "bank_0")
        }
        else {
            cell.iconImageView?.sd_setImage(with: URL(string: cashVO.bank_logo), placeholderImage: UIImage(named: "bank_0"))
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        /*  tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cashVO = dataList.objectAtIndex(indexPath.row) as! MyBankListVO
        
        
        let vc = CashViewController(nibName: "CashViewController", bundle: nil)
        vc.model = cashVO
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    //MARK: -BankListCellDelegate
    func deleteBankCard(_ index: IndexPath?){
        
        if index != nil {
            
            let cashVO = dataList.object(at: index!.row) as! MyBankListVO
            
            self.showHud(in: self.view,hint:"")
            weak var weakSelf = self
            
            self.unLockBankCard(cashVO.bank_id,success:{() -> Void in
                
                weakSelf!.hideHud()
                weakSelf!.showHint("解绑成功")
                weakSelf!.dataList.remove(cashVO)
                weakSelf!.tableView?.reloadData()
                
                },failed:{(msg) -> Void in
                    weakSelf!.hideHud()
                    weakSelf!.showHint(msg)
                    
            })
            
        }
    }
    
    
}
