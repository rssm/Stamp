//
//  StampData.swift
//  Stamp
//
//  Created by Rafael Sol Santos Martins on 15/08/18.
//  Copyright © 2018 Rafael Sol Santos Martins. All rights reserved.
//

import Foundation

class StampData{
    
    var city : String?
    var country : String?
    var date : String?
    var centerX : Double?
    var centerY : Double?
    
    init(city:String, country:String, date:String, centerX:Double, centerY:Double){
        self.city = city
        self.country = country
        self.date = date
        self.centerX = centerX
        self.centerY = centerY
    }
    
}
