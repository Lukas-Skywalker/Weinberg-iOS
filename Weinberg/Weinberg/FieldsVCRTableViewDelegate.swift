//
//  FieldsVCRTableViewDelegate.swift
//  Weinberg
//
//  Created by ema on 04.07.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

/*
 *@autor Johannes Strauss
 *@email johannes.a.strauss@th-bingen.de
 *@version 1.0
 *
 * This Class handels All TableView related functions for the
 * FieldViewController
 */

class FieldsVCRTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {

    let realm = try! Realm()
    // The List of Fields
    var fields: Results<Field>?
    // The navigationController for opening the EditOperationViewController
    let navigationController: UINavigationController
       // The tabbarController for switching to the map
    let tabbarController: UITabBarController
    
    /*
     * Initializes the DataSource, the NavigationController and the TabbarController in order to display all fields
     */
    init(fields: Results<Field>, navbarController: UINavigationController, tabbarController: UITabBarController){
        self.fields = fields
        self.navigationController = navbarController
        self.tabbarController = tabbarController
    }
    
    // return the number of elements in the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (DataManager.shared.currentOperation != nil) {
            if(fields == nil){
                fields = realm.objects(Field.self)
            }
            return fields!.count
        }
        return 0
    }
    
    /*
     * Creates an empty OperationDetailCell and fills the labels within the cell with the correct data.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields![indexPath.row]
        let cellIdentifier = "FieldDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FieldDetailCell
        
        cell.name.text = field.name
        cell.size.text = String(describing: field.area)
        cell.checkBox.field = nil
        cell.checkBox.isChecked = (DataManager.shared.currentOperation?.done.contains(field))!
        cell.checkBox.field = field
        cell.checkBox.accessibilityIdentifier = "checkFieldStatus"
        cell.viewBackground.layer.shadowColor = UIColor.black.cgColor
        cell.viewBackground.layer.shadowOpacity = 0.2
        cell.viewBackground.layer.shadowOffset = CGSize.init(width: -1, height: 1)
        cell.viewBackground.layer.shadowRadius = 1
        cell.accessibilityIdentifier = "FieldCell"
        
        return cell
    }
  
    /*
     * Handles swipe-events and the editing or deleting of the selected field.
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Editieren", handler: {(action,indexPath) in
            let field:Field = self.fields![indexPath.row]
            let storyBoard: UIStoryboard = UIStoryboard(name:"Field",bundle:nil)
            let editController : EditFieldViewController = storyBoard.instantiateViewController(withIdentifier: "EditField") as! EditFieldViewController
            editController.field = field
            self.navigationController.pushViewController(editController, animated: true)
        })
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Löschen", handler: {(action,indexPath) in
            let results = self.realm.objects(Operation.self)
            let toDelete = self.fields![indexPath.row]
            try! self.realm.write {
                for operation in results {
                    if (operation.done.contains(toDelete)) {
                        operation.doneArea -= toDelete.area
                    }
                }
                
                self.realm.delete(toDelete)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
    /*
     *Handles clicks on the Field detailCell
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field:Field = self.fields![indexPath.row];
        DataManager.shared.currentField = CLLocationCoordinate2D(latitude: (field.boundaries.first?.lat)!, longitude: (field.boundaries.first?.lng)!)
        tabbarController.selectedIndex = 1
    }
}
