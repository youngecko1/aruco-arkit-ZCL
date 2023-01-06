//
//  Cabinet.swift
//  cvAruco
//
//  Created by Young Won Choi on 2022/10/28.
//  Copyright © 2022 Dan Park. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

public class Cabinet {
    
    public var aruco_id: Int!
    var full_count: Int!
    var img: String!
    var last_takein: Timestamp!
    var last_takeout: Timestamp!
    var last_update: Timestamp!
    var location: String!
    var pred_takein: Timestamp!
    var product_id: String!
    var prod_name: String!
    var usage: NSArray!
    var remainder: String!
    
    init (id: Int, count: Int, image: String, lti: Timestamp, lto: Timestamp, lu: Timestamp, location: String, pti: Timestamp, prodID: String, prodName: String, use: NSArray, remain: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm"
        
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
        self.remainder = remain
    }
    
    
    
}
