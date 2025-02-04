//
//  ImageStorage.swift
//  Image
//
//  Created by Elizaveta on 27.01.2025.
//

import SwiftUI
import CoreData

final class ImageStorage: ObservableObject {
    
    private let persistenceController: PersistenceController
    private var context: NSManagedObjectContext {
        persistenceController.viewContext
    }
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func writeImage(uiImage: UIImage) {
        guard let data = uiImage.pngData() else { return }
        let image = FoxImage(context: context)
        
        image.data = data
        image.uuid = UUID()
        
        DispatchQueue.main.async {
            do {
                try self.context.save()
                print("изображение сохранено")
            } catch {
                print("Ошибка сохранения в базу данных")
            }
        }
    }
    
    func edit(objectID: NSManagedObjectID?, fox: Fox) {
        guard
            let objectID = objectID,
            var image = try? self.context.existingObject(with: objectID) as? FoxImage
        else {
            return
        }
        
        if let name = fox.name {
            image.name = name
        }
        
        if let discription = fox.discription {
            image.discription = discription
        }
        
        if let age = fox.age {
            image.age = age
        }
        
        do {
            try self.context.save()
            print("комментарий добавлен")
            print(image)
        } catch {
            print("Ошибка")
        }
    }
    
    func delete(at offsets: IndexSet, images: [FoxImage]) {
        offsets.map { images[$0] }.forEach(context.delete)
        
        do {
            try context.save()
        } catch {
            print("Ошибка удаления изображение")
        }
    }
    
    func fetchImages() -> [FoxImage] {
        let fetchRequest: NSFetchRequest<FoxImage> = FoxImage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FoxImage.uuid, ascending: true)]
        
        var images: [FoxImage] = []
        
        do {
            images = try context.fetch(fetchRequest)
        } catch {
            print("Ошибка при загрузке изображений: \(error.localizedDescription)")
        }
        return images
    }
    
    func deleteAll() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "FoxImage"))
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let deleteRequestResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
            guard let deletedPlaceIds = deleteRequestResult?.result as? [NSManagedObjectID] else {
                return
            }
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedPlaceIds], into: [context])
        } catch {
            print("Ошибка при удалении всех изображений: \(error.localizedDescription)")
        }
    }
    
}
