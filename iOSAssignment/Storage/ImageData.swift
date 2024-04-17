//
//  ImageData.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 17/04/24.
//

import Foundation
import CoreData

public class ImageData: NSManagedObject {
    
    convenience init (context: NSManagedObjectContext, data: (String?, String) ) {
        self.init(context: context)
        id = data.0
        imageUrl = data.1
    }
}
