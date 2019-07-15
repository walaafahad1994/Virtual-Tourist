//
//  Pin+Extension.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 6/29/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//

import Foundation
import MapKit
extension Pin
{
    var coord:CLLocationCoordinate2D
    {
        set{
       lat = newValue.latitude
       long = newValue.longitude
        }
        get
        {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
    
    func isEqual(to Cord:CLLocationCoordinate2D) -> Bool {
        return (lat == Cord.latitude && long == Cord.longitude )
    }
    
        
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
