//
//  Timezone+CoreDataProperties.swift
//  TimeToTime
//
//  Created by Paul Jarysta on 15/11/2015.
//  Copyright © 2015 Paul Jarysta. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Timezone {

    @NSManaged var locality: String?
    @NSManaged var timezone: String?
    @NSManaged var offset: String?
    @NSManaged var abbreviation: String?

}
