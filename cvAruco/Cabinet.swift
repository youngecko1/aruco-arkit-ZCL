//
//  Cabinet.swift
//  cvAruco
//
//  Created by Young Won Choi on 2022/10/28.
//  Copyright © 2022 Dan Park. All rights reserved.
//

import Foundation

public class Cabinet {
    
    open var someString: String!
    public var aruco_id: Int!
    var full_count: Int!
    var img: URL!
    var last_takein: String!
    var last_takeout: String!
    var last_update: String!
    var location: String!
    var pred_takein: String!
    var product_id: String!
    var prod_name: String!
    var usage: NSArray!
    var volume: String!
    
    init (id: Int, count: Int, image: URL, lti: String, lto: String, lu: String, location: String, pti: String, prodID: String, prodName: String, use: NSArray, remain: String){
        self.aruco_id = id
        self.full_count = count
        self.img = image
        self.last_takein = lti
        self.last_takeout = lto
        self.last_update = lu
        self.location = location
        self.pred_takein = pti
        self.product_id = prodID
        self.prod_name = prodName
        self.usage = use
        self.volume = remain
        self.someString = "String"
    }
    
    public var point:String {
        get{
            return someString
        }
    }
    
}
