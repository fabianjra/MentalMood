//
//  Mood+CoreDataProperties.swift
//  SereneCheck
//
//  Created by Edgar Alexis Negrete Hernandez on 16/03/23.
//
//

import Foundation
import CoreData

extension Mood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mood> {
        return NSFetchRequest<Mood>(entityName: "Mood")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var status: String?
    @NSManaged public var tasks: NSSet?

    func getTasksArray() -> [Task] {
        return tasks?.allObjects as? [Task] ?? []
    }
}

// MARK: Generated accessors for tasks
extension Mood {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

    var formattedDateShort: String {
        date?.formatted(date: .abbreviated, time: .omitted ) ?? ""
    }
}

extension Mood: Identifiable {

}
