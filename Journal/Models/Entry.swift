//
//  Item.swift
//  Journal
//
//  Created by Mélissa Kintz on 03/07/2023.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class Entry {
    @Attribute(.unique) public var id: String
    var createdAt: Date
    var location: [String]?
    var content: String
    var drawing : Data?

    
    init(createdAt: Date = .now, location: [String]?, content: String = "") {
        self.id = UUID().uuidString
        self.createdAt = createdAt
        self.location = location
        self.content = content
    }
}

extension Entry {
    
    public func getPlacemark() async -> CLPlacemark? {
        let geocoder = CLGeocoder()
                
        if let location {
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(CLLocation(latitude: Double(location[0])!, longitude: Double(location[1])!))
                
                if let placemark = placemarks.first {
                    return placemark
                } else {
                    print("*** Error in \(#function): placemark is nil")
                }
            } catch {
                print("*** Error in \(#function): \(error.localizedDescription)")
            }
            
        }
        return nil
    }
 
}
