//
//  TitleItem+CoreDataClass.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 5/10/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(TitleItem)
public class TitleItemName: NSManagedObject {
    static let shared = TitleItemName()
    
    enum DataBaseError: Error {
        case failedToDownload
    }
    
    func downloadTitleWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItemName(context: context)
        item.id = Int64(model.id ?? 0)
        item.overview = model.overview
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count ?? 0)
        item.vote_average = model.vote_average ?? 0
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDownload))
            print(error.localizedDescription)
        }
    }
}
