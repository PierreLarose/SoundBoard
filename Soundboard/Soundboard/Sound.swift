//
//  Sound.swift
//  Soundboard
//
//  Created by Pierre Larose on 9/24/14.
//  Copyright (c) 2014 Pierre Larose. All rights reserved.
//

import Foundation
import CoreData

class Sound: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var url: String

}
