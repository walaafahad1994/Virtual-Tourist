//
//  Photos+Extension.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 6/29/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//

import Foundation
import UIKit
extension Photo
{
    func setImage(image :UIImage)
    {
        self.imageData = image.pngData()
    }
    func getImage() -> UIImage? {
        return (imageData == nil) ? nil : UIImage(data:imageData!)
    }
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
