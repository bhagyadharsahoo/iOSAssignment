//
//  CoredataManager.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 17/04/24.
//

import Foundation
import CoreData

final class CoreDataManager {
        let frameworkBundleID = "com.test.com.iOSAssignment"
        let modelName = "Data"

        static let shared = CoreDataManager()

        private init() {}

        // MARK: - Core Data stack

        private lazy var persistentContainer: NSPersistentContainer = {
            let frameworkBundle = Bundle(identifier: self.frameworkBundleID)!
            let modelURL = frameworkBundle.url(forResource: self.modelName, withExtension: "momd")!
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            let container = NSPersistentContainer(name: self.modelName, managedObjectModel: managedObjectModel!)

            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    // TODO: - Log to Crashlytics
                    assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
                }
                container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            }
            return container
        }()

        lazy var context: NSManagedObjectContext = persistentContainer.viewContext

//        lazy var backgroundContext: NSManagedObjectContext = persistentContainer.createBackground()

        // MARK: - Core Data Saving support

        func saveContext() {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // TODO: - Log to Crashlytics
                    assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
                }
            }
        }

        func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
            persistentContainer.performBackgroundTask(block)
        }

        public func clearAllCoreData() {
            let entities = persistentContainer.managedObjectModel.entities
            entities.compactMap(\.name).forEach(clearDeepObjectEntity)
        }

        func clearDeepObjectEntity(_ entity: String) {
            let context = persistentContainer.viewContext

            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
               print(error.localizedDescription)
            }
        }
    }
    
