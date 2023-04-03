//
//  Task+CoreDataProperties.swift
//  SereneCheck
//
//  Created by Edgar Alexis Negrete Hernandez on 16/03/23.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var origin: Mood?

}

extension Task: Identifiable {

}
