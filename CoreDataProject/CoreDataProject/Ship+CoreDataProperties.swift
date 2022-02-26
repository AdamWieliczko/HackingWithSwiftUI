//
//  Ship+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Student2 on 11/02/2022.
//
//

import Foundation
import CoreData


extension Ship {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ship> {
        return NSFetchRequest<Ship>(entityName: "Ship")
    }

    @NSManaged public var name: String?
    @NSManaged public var universe: String?

}

extension Ship : Identifiable {

}
