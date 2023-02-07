//
//  PlacesFavoritesDelegate.swift
//  Chicago Landmark
//
//  Created by Sung-Jie Hung on 2023/2/6.
//

import Foundation

protocol PlacesFavoritesDelegate: AnyObject {
    func favoritePlace(name: String) -> Void
}
