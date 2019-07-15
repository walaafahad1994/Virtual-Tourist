//
//  DataController.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 6/26/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//

import Foundation
import CoreData
class DataController {
    
    static let shared = DataController()

    let presistentContainer = NSPersistentContainer(name:"virtualTouristDataBase")
        var viewContext:NSManagedObjectContext {
        return presistentContainer.viewContext
    }
 
   init() {
    
    }

    func load(completion:(()->Void)? = nil)
    {
        presistentContainer.loadPersistentStores { (storeDescrpiton
            , error) in
            guard error == nil else
            {
                fatalError(error!.localizedDescription)
                
            }
           // self.AutoSaveContext()
            completion?()
        }
    }
    
    
    
}


