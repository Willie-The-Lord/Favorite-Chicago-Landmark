//
//  DataManager.swift
//  Chicago Landmark
//
//  Created by Sung-Jie Hung on 2023/2/6.
//

import Foundation
import MapKit

public class DataManager {
    
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    
    // Stored data in plist
    // https://stackoverflow.com/questions/56936974/how-to-use-a-plist-as-a-kind-of-storage-in-swift
    var plist = NSDictionary()
    var myFavorites = [String]()
    var myAnnotations = [Place]()
    
    fileprivate init() {
        loadAnnotationFromPlist()
    }
    
    func loadAnnotationFromPlist() {
        plist = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!)!
    }
    
    // Check whether the favorites place is in the list or not
    func isFavorite(name: String) -> Bool {
        return myFavorites.contains(name)
    }
    
    // Save
    func saveFavorite(name: String) {
        myFavorites.append(name)
    }
    
    // Delete
    func deleteFavorite(name: String) {
        var deleteIndex = 0
        for i in 0 ..< myFavorites.count {
            if myFavorites[i] == name {
                deleteIndex = i
            }
        }
        myFavorites.remove(at: deleteIndex)
    }
    
    // Delete
    func deleteFavoriteIndex(index: Int) {
        myFavorites.remove(at: index)
    }
    
    // CLLocationCoordinate2D
    // https://developer.apple.com/documentation/corelocation/cllocationcoordinate2d
    func getRegion(name: String) -> MKCoordinateRegion? {
        for annotation in myAnnotations {
            if annotation.title == name {
                let miles: Double = 3 * 600
                let centerPoint = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
                let viewRegion = MKCoordinateRegion(center: centerPoint, latitudinalMeters: miles, longitudinalMeters: miles)
                return viewRegion
            }
        }
        return nil
    }
    
    func getDescription(name: String) -> String? {
        for annotation in myAnnotations {
            if annotation.title == name {
                return annotation.longDescription
            }
        }
        return nil
    }
    
    
    func loadRegion() -> MKCoordinateRegion {
        let region = plist["region"]! as? [Double]
        let miles: Double = 3 * 600
        let centerPoint = CLLocationCoordinate2DMake(region![0], region![1])
        let viewRegion = MKCoordinateRegion(center: centerPoint, latitudinalMeters: miles, longitudinalMeters: miles)
        return viewRegion
    }
    
    // Custom annotations
    // https://stackoverflow.com/questions/43079169/ios-loading-custom-annotations
    func loadAnnotations() -> [Place] {
        let places = plist["places"]! as? [NSDictionary]
        for place in places! {
            let annotation = Place()
            annotation.name = place["name"]! as? String
            annotation.title = place["name"]! as? String
            annotation.longDescription = place["description"]! as? String
            if let lat = place["lat"]! as? Double, let long = place["long"]! as? Double{
                annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                myAnnotations.append(annotation)
            }
        }
        return myAnnotations
    }
}
