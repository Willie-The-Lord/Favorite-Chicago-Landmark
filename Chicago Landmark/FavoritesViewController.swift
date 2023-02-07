//
//  FavoritesViewController.swift
//  Chicago Landmark
//
//  Created by Sung-Jie Hung on 2023/2/6.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var myTableView: UITableView!
    weak var delegate: PlacesFavoritesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    // Can edit row
    // https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614900-tableview
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    @IBAction func tapDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.myFavorites.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = DataManager.sharedInstance.myFavorites[indexPath.row]
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Send the information of the tapped cell to the MapViewController
        delegate?.favoritePlace(name: DataManager.sharedInstance.myFavorites[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    // Swipe to delete favorite places
    // https://www.hackingwithswift.com/example-code/uikit/how-to-remove-cells-from-a-uitableview
    // https://developer.apple.com/documentation/uikit/uitableviewdelegate/2902367-tableview
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                
                // delete the item here
                print("\(indexPath)")
                DataManager.sharedInstance.deleteFavoriteIndex(index: indexPath.row)
                self.myTableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
