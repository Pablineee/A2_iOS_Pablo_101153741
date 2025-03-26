//
//  Product+CoreDataProperties.swift
//  lab-test-2-app
//
//  Created by Pablo on 2025-03-26.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productId: Int32
    @NSManaged public var productName: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productPrice: Double
    @NSManaged public var productProvider: String?

}

extension Product : Identifiable {

}
