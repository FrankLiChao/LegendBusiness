//
//  DealURL.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/17.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit
import Foundation

extension URL {

    init?(myString URLString: String){

        
        
        //let url =  URLString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())

        //self.init(string:url!)
        let nsurl: NSURL = NSURL(string: URLString)!
        self = nsurl as URL
    }
}
