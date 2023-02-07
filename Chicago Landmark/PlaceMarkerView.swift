//
//  PlaceMarkerView.swift
//  Chicago Landmark
//
//  Created by Sung-Jie Hung on 2023/2/6.
//

import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = UIColor.black
            glyphImage = UIImage(systemName: "pin.fill")
        }
    }
}
