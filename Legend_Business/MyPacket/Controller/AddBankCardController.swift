//
//  AddBankCardController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/23.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class AddBankCardController: BaseViewController {

    weak var delegate : AddBankTableControllerDelegate?
    var bFromCash: Bool?//是否来至提现页面
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
       self.setBackButton()
        
        let backButton = UIButton(type: .custom)
        
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 44);

        backButton.contentHorizontalAlignment = .left;
        backButton.setImage(UIImage(named: "back"), for: UIControl.State())
        backButton.addTarget(self, action: #selector(AddBankCardController.back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.title = "绑定银行卡"
        
    }

    @objc func back(){
    
    
        if bFromCash != nil && bFromCash! {
        
            let desVc = self.navigationController?.viewControllers[1]
            let _ = self.navigationController?.popToViewController(desVc! , animated: true)
        }
        else{
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "AddBankSegue" {
        
            let vc = segue.destination as! AddBankTableController
            vc.delegate = delegate
            
        }
    }


}
