//
//  GoodsModel.swift
//  legend_business_ios
//
//  Created by heyk on 16/2/24.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit


class GoodsModel {
    var goodsName: String = ""
    var totalStock: Int = 0
    var salesVolume: Int = 0
    var price: Double = 0
    var isOnSale: Bool = true
    var goodsImgs: [String] = []
}

class GoodsDetailModel: GoodsModel {
    var categoryId: Int = 0
    var categoryName: String = ""
    var isEndorse: Bool = false
    var freight: Double = 0 //运费
    var freePostage: Double = 0 //包邮
}

class AttrGoodsModel: GoodsDetailModel {
    var goodsAttrs: [AttributeModel] = []
}
