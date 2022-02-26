//
//  Wizard+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Student2 on 11/02/2022.
//
//

import Foundation
import CoreData


extension Wizard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wizard> {
        return NSFetchRequest<Wizard>(entityName: "Wizard")
    }

    @NSManaged public var name: String?

}

extension Wizard : Identifiable {

}
