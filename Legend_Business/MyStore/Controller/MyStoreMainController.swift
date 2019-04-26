//
//  MyStoreMainController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/18.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class MyStoreMainController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的店铺"
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "test", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.clickTest))
    }
    
    @objc func clickTest() -> Void {
        let vc = WeekBonusViewController()
        self.navigationController?.pushViewController(vc,animated:true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
