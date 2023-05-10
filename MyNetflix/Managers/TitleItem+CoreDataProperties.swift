//
//  TitleItem+CoreDataProperties.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 5/10/23.
//
//

import Foundation
import CoreData


extension TitleItemName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TitleItemName> {
        return NSFetchRequest<TitleItemName>(entityName: "TitleItemName")
    }

    @NSManaged public var id: Int64
    @NSManaged public var media_type: String?
    @NSManaged public var original_name: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int64

}

extension TitleItemName : Identifiable {

}
