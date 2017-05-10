//
//  PasswordManagController.swift
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/21.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class PasswordManagController: BaseViewController , UITableViewDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton()
        self.title = "密码管理"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {return 0}
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
         tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
        
            let vc = CashPasswordFirstSetingViewController(nibName: "CashPasswordFirstSetingViewController", bundle: nil)
            vc.type = SMSType_SetPayPWD;
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "passwordManageSegue" {
        
            let vc = segue.destination as! UITableViewController
            vc.tableView.delegate = self
        }
       
    }


}
