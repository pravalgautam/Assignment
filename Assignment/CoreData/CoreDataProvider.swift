//
//  CoreDataProvider.swift
//  Assignment
//
//  Created by Praval Gautam on 14/02/25.
//

import Foundation
import CoreData

class CoreDataProvider:ObservableObject{
    var container =   NSPersistentContainer(name: "FavoriteModel")
     init(){

        container.loadPersistentStores { desc, error in
            if let error {
                fatalError("erorrrrr")
            }
        }
    }
}

