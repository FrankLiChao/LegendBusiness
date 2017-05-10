//
//  RefrshHeader.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/22.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

typealias headerRefreshBlock = (MJRefreshHeader) -> Void
typealias footerRefreshBlock = (MJRefreshFooter) -> Void

extension UITableView {

    
    func addRefreshHeader( _ block : @escaping headerRefreshBlock){
    
        
         self.mj_header =  MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            
           
            block(self.mj_header)
            
        })
        
    }
    
    func addRefreshFooter(_ block : @escaping footerRefreshBlock){
    
        self.mj_footer = MJRefreshAutoFooter(refreshingBlock: { () -> Void in
            
            block(self.mj_footer)
        })
    }
    
    

}
