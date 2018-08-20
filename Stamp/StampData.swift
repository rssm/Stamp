//
//  StampData.swift
//  Stamp
//
//  Created by Rafael Sol Santos Martins on 15/08/18.
//  Copyright © 2018 Rafael Sol Santos Martins. All rights reserved.
//

import Foundation

class StampData : NSObject, NSCoding, NSSecureCoding{
    
    static var supportsSecureCoding: Bool{
        return true
    }
    
    var city : String?
    var country : String?
    var date : String?
    var centerX : Double?
    var centerY : Double?
    
    init(city:String, country:String, date:String, centerX:Float64, centerY:Float64){
        self.city = city
        self.country = country
        self.date = date
        self.centerX = centerX
        self.centerY = centerY
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.city, forKey: "city")
        aCoder.encode(self.country, forKey: "country")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.centerX, forKey: "centerX")
        aCoder.encode(self.centerY, forKey: "centerY")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let city = aDecoder.decodeObject(forKey: "city") as! String
        let country = aDecoder.decodeObject(forKey: "country") as! String
        let date = aDecoder.decodeObject(forKey: "date") as! String
        let centerX = aDecoder.decodeObject(forKey: "centerX") as! Double
        let centerY = aDecoder.decodeObject(forKey: "centerY") as! Double
        self.init(city: city, country: country, date: date, centerX: centerX, centerY: centerY)
    }
    
}
