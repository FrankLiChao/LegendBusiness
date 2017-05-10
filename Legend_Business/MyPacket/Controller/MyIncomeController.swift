//
//  MyIncomeController.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/22.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class MyIncomeController: BaseViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的收入"
        self.setBackButton()
        self.addRightBarItem("收入记录", method: #selector(MyIncomeController.clickIncomeList))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
   
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
   
    }

    
    func clickIncomeList(){
    
        let story : UIStoryboard = UIStoryboard(name: "Store", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "IncomeListController") as!  IncomeListController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
