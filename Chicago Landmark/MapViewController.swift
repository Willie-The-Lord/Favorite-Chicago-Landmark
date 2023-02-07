//
//  MapViewController.swift
//  Chicago Landmark
//
//  Created by Sung-Jie Hung on 2023/2/6.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // Labels && Views
    @IBOutlet var myMapView: MKMapView!
    @IBOutlet var myHUD: UIView!
    @IBOutlet var myTitle: UILabel!
    @IBOutlet var myDescription: UILabel!
    
    // Buttons
    @IBOutlet var myStarButton: UIButton!
    @IBOutlet var myFavoriteButton: UIButton!
    var starButtonOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the the MapViews properties so that it does not show any of the Apple provided points of interests. We will be using our own. Disable the compass so that it doesn't over crowd our interface.
        // https://stackoverflow.com/questions/48713377/how-to-show-mapkit-compass
        myMapView.showsCompass = false
        myMapView.pointOfInterestFilter = .excludingAll
        myMapView.setRegion(DataManager.sharedInstance.loadRegion(), animated: true)
        myMapView.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        myMapView.addAnnotations(DataManager.sharedInstance.loadAnnotations())
        myMapView.delegate = self
        
        myTitle.textColor = UIColor.white
        myTitle.numberOfLines = 2
        myTitle.lineBreakMode = .byWordWrapping
        myTitle.text = DataManager.sharedInstance.myAnnotations.first?.title
        
        myHUD.alpha = 0.8
        myHUD.backgroundColor = UIColor.black
        myHUD.layer.cornerRadius = 10.0
        
        myFavoriteButton.backgroundColor = UIColor.black
        myFavoriteButton.layer.cornerRadius = 10.0
        
        myDescription.textColor = UIColor.white
        myDescription.numberOfLines = 4
        myDescription.lineBreakMode = .byWordWrapping
        myDescription.text = DataManager.sharedInstance.myAnnotations.first?.longDescription
    }
    
    // Change the map view size && HUD position when rotating iPhone
    // https://developer.apple.com/documentation/uikit/uiviewcontroller/2866515-viewwilltransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            // Always position the My Favorite Button at the bottom of the frame
            self.myFavoriteButton.center = CGPoint(x: size.width / 2, y: size.height * (6/7))
            
           // Different map view size
            if size.width > size.height {
                self.myMapView.frame = CGRect(x: 0, y: 0, width: 842, height: 396)
//                self.myHUD.center = CGPoint(x: 68, y: 40)
            } else {
                self.myMapView.frame = CGRect(x: 0, y: 0, width: 396, height: 842)
//                self.myHUD.center = CGPoint(x: size.width / 2, y: size.height * (2/7))
            }
        }, completion: nil)
    }
    
    // Change the state of your favorite places when pressing the STAR button
    @IBAction func pressStarButton(_ sender: Any) {
        if starButtonOn {
            starButtonOn = false
            myStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            DataManager.sharedInstance.deleteFavorite(name: myTitle.text!)
        } else {
            starButtonOn = true
            myStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            DataManager.sharedInstance.saveFavorite(name: myTitle.text!)
        }
    }
    
    // Show the favorite places list
    @IBAction func pressFavoriteButton(_ sender: Any) {
        // https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller
        let favoritesViewController = self.storyboard?.instantiateViewController(identifier: "FavoritesViewController") as! FavoritesViewController
        // Present the popup favorite places list
        if let sheet = favoritesViewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .large
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(favoritesViewController, animated: true, completion: nil)
        favoritesViewController.delegate = self
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation as? Place
        // My HUD
        myTitle.text = selectedAnnotation?.name
        myDescription.text = selectedAnnotation?.longDescription
        if let title = myTitle.text {
            if DataManager.sharedInstance.isFavorite(name: title) {
                starButtonOn = true
                myStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                starButtonOn = false
                myStarButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
}

// Selecting the target favorite place
extension MapViewController: PlacesFavoritesDelegate {
    func favoritePlace(name: String) {
        // My HUD
        myTitle.text = name
        myDescription.text = DataManager.sharedInstance.getDescription(name: name)
        // Transit to target favorite place
        myMapView.setRegion(DataManager.sharedInstance.getRegion(name: name)!, animated: true)
        // Star button
        starButtonOn = true
        myStarButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
}
