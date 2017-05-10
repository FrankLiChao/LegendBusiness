//
//  ViewController.swift
//  Legend_Business
//
//  Created by heyk on 16/2/15.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SYS_UI_COLOR_BG_COLOR  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setBackButton(){
        
        let backButton : UIButton = UIButton(type: .Custom)
        backButton.frame = CGRectMake(0, 0, 60, 44)
        backButton.contentHorizontalAlignment = .Left
        backButton.setImage(UIImage(named: "back"), forState:.Normal)
        backButton.addTarget(self, action: Selector("clickBack:"), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func clickBack(button:UIButton?){
    
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func addRightBarItem(imageName:String, select: Selector){
    
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, 60, 44)
        button.contentHorizontalAlignment = .Right
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.addTarget(self, action: select, forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    
}

