//
//  PhotoAnnotation.swift
//  Photo Map
//
//  Created by Luis Mendez on 10/17/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var photo: UIImage!
    var title: String? {
        return "\(coordinate.latitude)"
    }
}
